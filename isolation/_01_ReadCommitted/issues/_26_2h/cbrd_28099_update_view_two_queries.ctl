/*
Test Case: cbrd_28099_update_view_two_queries
Priority: 1
Reference case: CBRD-28099 (CUBRID/cubrid#8612)
Author: hgryoo

Test Point:
An UPDATE through a view of two queries (ALTER VIEW ... ADD QUERY) runs one statement per query and waits for the row of the second table in its update step. The prepared UPDATE applies the hint to that step: it times out. With no holder it updates both tables, and afterwards the lock timeout of the transaction is INFINITE again.

NUM_CLIENTS = 3
C1: UPDATE t28099_t2 SET k = 99 WHERE id = 2;
C2: UPDATE t28099_v2 SET k = k + 1000 WHERE k < 50;  -- with the hint LOCK_TIMEOUT(1); times out
C1: COMMIT;  -- 5 seconds after the statement of C2 started
C2: UPDATE t28099_v2 SET k = k + 1000 WHERE k < 50;  -- with the hint LOCK_TIMEOUT(1); no holder now, so it succeeds
C3: UPDATE t28099_x SET c = 1 WHERE id = 1;
C2: UPDATE t28099_x SET c = 2 WHERE id = 1;  -- waits for C3: the lock timeout of C2 is INFINITE again
C3: COMMIT;  -- 3 seconds later
C2: COMMIT;
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
C1: DROP VIEW IF EXISTS t28099_v;
C1: DROP VIEW IF EXISTS t28099_v2;
C1: DROP TABLE IF EXISTS t28099_t;
C1: DROP TABLE IF EXISTS t28099_t2;
C1: DROP TABLE IF EXISTS t28099_u;
C1: DROP TABLE IF EXISTS t28099_src;
C1: DROP TABLE IF EXISTS t28099_audit;
C1: DROP TABLE IF EXISTS t28099_x;
C1: CREATE TABLE t28099_t (id INT PRIMARY KEY, k INT) DONT_REUSE_OID;
C1: CREATE TABLE t28099_t2 (id INT PRIMARY KEY, k INT) DONT_REUSE_OID;
C1: INSERT INTO t28099_t VALUES (1, 10), (2, 20), (3, 30);
C1: INSERT INTO t28099_t2 VALUES (1, 11), (2, 21);
C1: CREATE VIEW t28099_v2 AS SELECT id, k FROM t28099_t;
C1: ALTER VIEW t28099_v2 ADD QUERY SELECT id, k FROM t28099_t2;
C1: CREATE TABLE t28099_x (id INT PRIMARY KEY, c INT);
C1: INSERT INTO t28099_x VALUES (1, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* the hint is in a string: the controller strips comments, hints included, from the commands it sends */
C2: PREPARE st28099 FROM 'UPDATE /*+ LOCK_TIMEOUT(1) */ t28099_v2 SET k = k + 1000 WHERE k < 50';
MC: wait until C2 ready;
C2: PREPARE st28099_1 FROM 'UPDATE /*+ LOCK_TIMEOUT(1) */ t28099_v2 SET k = k + 1000 WHERE k < 50';
MC: wait until C2 ready;
C1: UPDATE t28099_t2 SET k = 99 WHERE id = 2;
MC: wait until C1 ready;
C2: EXECUTE st28099;
/* longer than the hint: a statement that ignores the hint is still waiting when C1 ends */
MC: sleep 5;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: EXECUTE st28099_1;
MC: wait until C2 ready;
/* the lock timeout of C2 is INFINITE again: its UPDATE waits for C3 instead of timing out */
C3: UPDATE t28099_x SET c = 1 WHERE id = 1;
MC: wait until C3 ready;
C2: UPDATE t28099_x SET c = 2 WHERE id = 1;
/* longer than the hint: an UPDATE that kept the hint as its lock timeout has timed out by now */
MC: sleep 3;
C3: COMMIT;
MC: wait until C3 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 1, 1010), (1, 2, 1020), (1, 3, 1030), (2, 1, 1011), (2, 2, 99): only the second UPDATE changed rows */
C1: SELECT 1, id, k FROM t28099_t UNION ALL SELECT 2, id, k FROM t28099_t2 ORDER BY 1, 2;
MC: wait until C1 ready;
/* expect 2: the UPDATE of C2 waited for C3 and then ran */
C1: SELECT c FROM t28099_x;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP VIEW IF EXISTS t28099_v;
C1: DROP VIEW IF EXISTS t28099_v2;
C1: DROP TABLE IF EXISTS t28099_t;
C1: DROP TABLE IF EXISTS t28099_t2;
C1: DROP TABLE IF EXISTS t28099_u;
C1: DROP TABLE IF EXISTS t28099_src;
C1: DROP TABLE IF EXISTS t28099_audit;
C1: DROP TABLE IF EXISTS t28099_x;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
