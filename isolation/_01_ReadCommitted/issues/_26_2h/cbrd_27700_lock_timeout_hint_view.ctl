/*
Test Case: cbrd_27700_lock_timeout_hint_view
Priority: 1
Reference case: CBRD-27700 (CUBRID/cubrid#8463)
Author: hgryoo

Test Point:
The same as cbrd_27700_lock_timeout_hint_trigger for a DELETE through a view.

NUM_CLIENTS = 2
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
C2: DELETE FROM t27700_v WHERE k < 50;  -- with the hint LOCK_TIMEOUT(1); times out on row 2 after 1 second
C1: COMMIT;  -- 5 seconds after the DELETE started
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
C1: CREATE TABLE t27700_t (id INT PRIMARY KEY, k INT) DONT_REUSE_OID;
C1: INSERT INTO t27700_t VALUES (1, 10), (2, 20), (3, 30);
C1: CREATE VIEW t27700_v AS SELECT id, k FROM t27700_t;
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* the hint is in a string: the controller strips comments, hints included, from the commands it sends */
C2: PREPARE st27700 FROM 'DELETE /*+ LOCK_TIMEOUT(1) */ FROM t27700_v WHERE k < 50';
MC: wait until C2 ready;
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
MC: wait until C1 ready;
C2: EXECUTE st27700;
/* longer than the hint: a DELETE that ignores the hint is still waiting when C1 commits */
MC: sleep 5;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 10), (2, 99), (3, 30): the DELETE timed out and deleted nothing */
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
