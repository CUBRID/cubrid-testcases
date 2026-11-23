/*
Test Case: cbrd_27700_waited_row_deleted
Priority: 1
Reference case: CBRD-27700 (CUBRID/cubrid#8463)
Author: hgryoo

Test Point:
The holder deletes the waited row and commits. The client-side DELETE skips it without an error and deletes the other two rows. The BEFORE DELETE trigger records which transaction deleted each row.

NUM_CLIENTS = 2
C1: DELETE FROM t27700_t WHERE id = 2;
C2: DELETE FROM t27700_t WHERE k < 50;  -- waits for C1
C1: COMMIT;
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP VIEW IF EXISTS t27700_v;
C1: DROP VIEW IF EXISTS t27700_v2;
C1: DROP TABLE IF EXISTS t27700_t;
C1: DROP TABLE IF EXISTS t27700_u;
C1: DROP TABLE IF EXISTS t27700_x;
C1: DROP TABLE IF EXISTS t27700_audit;
C1: CREATE TABLE t27700_t (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t27700_audit (seq INT AUTO_INCREMENT PRIMARY KEY, who INT);
C1: INSERT INTO t27700_t VALUES (1, 10), (2, 20), (3, 30);
C1: CREATE TRIGGER t27700_trg BEFORE DELETE ON t27700_t EXECUTE INSERT INTO t27700_audit (who) VALUES (obj.id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27700_t WHERE id = 2;
MC: wait until C1 ready;
C2: DELETE FROM t27700_t WHERE k < 50;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect no rows */
C1: SELECT id, k FROM t27700_t ORDER BY id;
MC: wait until C1 ready;
/* expect 2 (by C1), then 1 and 3 (by C2) */
C1: SELECT who FROM t27700_audit ORDER BY seq;
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
