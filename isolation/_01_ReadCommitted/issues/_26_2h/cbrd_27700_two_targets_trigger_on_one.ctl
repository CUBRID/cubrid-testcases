/*
Test Case: cbrd_27700_two_targets_trigger_on_one
Priority: 1
Reference case: CBRD-27700 (CUBRID/cubrid#8463)
Author: hgryoo

Test Point:
A DELETE of two targets runs on the client when only one of them has a row DELETE trigger. The target without a trigger (t27700_t) must also skip the row that another transaction moved out of the WHERE clause.

NUM_CLIENTS = 2
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
C2: DELETE t27700_t, t27700_u FROM t27700_t INNER JOIN t27700_u ON t27700_t.id = t27700_u.id WHERE t27700_t.k < 50;  -- waits for C1
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
C1: CREATE TABLE t27700_u (id INT PRIMARY KEY);
C1: INSERT INTO t27700_u VALUES (1), (2), (3);
C1: CREATE TRIGGER t27700_trg AFTER DELETE ON t27700_u EXECUTE INSERT INTO t27700_audit (who) VALUES (0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
MC: wait until C1 ready;
C2: DELETE t27700_t, t27700_u FROM t27700_t INNER JOIN t27700_u ON t27700_t.id = t27700_u.id WHERE t27700_t.k < 50;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (2, 99) only: the DELETE skipped the row that C1 moved out of k < 50 */
C1: SELECT id, k FROM t27700_t ORDER BY id;
MC: wait until C1 ready;
/* expect 2 only: the joined row of t27700_u stays too */
C1: SELECT id FROM t27700_u ORDER BY id;
MC: wait until C1 ready;
/* expect 2: the trigger fired for the two deleted rows of t27700_u only */
C1: SELECT COUNT(*) FROM t27700_audit;
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
