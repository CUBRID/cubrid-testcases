/*
Test Case: cbrd_27700_view
Priority: 1
Reference case: CBRD-27700 (CUBRID/cubrid#8463)
Author: hgryoo

Test Point:
The same as cbrd_27700_trigger of this directory, for a DELETE through a view (SERIALIZABLE).

NUM_CLIENTS = 2
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
C2: DELETE FROM t27700_v WHERE k < 50;  -- waits for C1
C1: COMMIT;
C2: (the DML ends with a serialization conflict) ROLLBACK;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level serializable;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level serializable;

/* preparation */
C1: DROP VIEW IF EXISTS t27700_v;
C1: DROP VIEW IF EXISTS t27700_v2;
C1: DROP TABLE IF EXISTS t27700_t;
C1: DROP TABLE IF EXISTS t27700_u;
C1: DROP TABLE IF EXISTS t27700_x;
C1: DROP TABLE IF EXISTS t27700_audit;
C1: CREATE TABLE t27700_t (id INT PRIMARY KEY, k INT) DONT_REUSE_OID;
C1: INSERT INTO t27700_t VALUES (1, 10), (2, 20), (3, 30);
C1: CREATE VIEW t27700_v AS SELECT id, k FROM t27700_t;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
MC: wait until C1 ready;
C2: DELETE FROM t27700_v WHERE k < 50;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: ROLLBACK;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 10), (2, 99), (3, 30) */
C1: SELECT id, k FROM t27700_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
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
