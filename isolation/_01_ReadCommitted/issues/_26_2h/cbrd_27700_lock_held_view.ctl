/*
Test Case: cbrd_27700_lock_held_view
Priority: 1
Reference case: CBRD-27700 (CUBRID/cubrid#8463)
Author: hgryoo

Test Point:
The same as cbrd_27700_lock_held_trigger for a DELETE through a view of the table.

NUM_CLIENTS = 3
C1: UPDATE t27700_x SET c = 100 WHERE id = 1;
C2: DELETE FROM t27700_v WHERE k < 50;  -- its trigger waits for C1 at the first row
C3: UPDATE t27700_t SET k = 99 WHERE id = 3;  -- must wait for C2
C1: COMMIT;
C2: COMMIT;
C3: COMMIT;
*/

MC: setup NUM_CLIENTS = 3;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP VIEW IF EXISTS t27700_v;
C1: DROP VIEW IF EXISTS t27700_v2;
C1: DROP TABLE IF EXISTS t27700_t;
C1: DROP TABLE IF EXISTS t27700_u;
C1: DROP TABLE IF EXISTS t27700_x;
C1: DROP TABLE IF EXISTS t27700_audit;
C1: CREATE TABLE t27700_t (id INT PRIMARY KEY, k INT) DONT_REUSE_OID;
C1: INSERT INTO t27700_t VALUES (1, 10), (2, 20), (3, 30);
C1: CREATE TABLE t27700_x (id INT PRIMARY KEY, c INT);
C1: INSERT INTO t27700_x VALUES (1, 0);
C1: CREATE TRIGGER t27700_trg BEFORE DELETE ON t27700_t EXECUTE UPDATE t27700_x SET c = c + 1 WHERE id = 1;
C1: CREATE VIEW t27700_v AS SELECT id, k FROM t27700_t;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27700_x SET c = 100 WHERE id = 1;
MC: wait until C1 ready;
C2: DELETE FROM t27700_v WHERE k < 50;
MC: wait until C2 blocked;
/* row 3 is a target C2 has not reached; it was locked when C2 collected its targets */
C3: UPDATE t27700_t SET k = 99 WHERE id = 3;
MC: wait until C3 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect no rows */
C1: SELECT id, k FROM t27700_t ORDER BY id;
MC: wait until C1 ready;
/* expect 103 */
C1: SELECT c FROM t27700_x;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP VIEW IF EXISTS t27700_v;
C1: DROP VIEW IF EXISTS t27700_v2;
C1: DROP TABLE IF EXISTS t27700_t;
C1: DROP TABLE IF EXISTS t27700_u;
C1: DROP TABLE IF EXISTS t27700_x;
C1: DROP TABLE IF EXISTS t27700_audit;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
