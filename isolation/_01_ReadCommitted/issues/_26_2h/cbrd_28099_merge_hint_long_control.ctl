/*
Test Case: cbrd_28099_merge_hint_long_control
Priority: 1
Reference case: CBRD-28099 (CUBRID/cubrid#8612)
Author: hgryoo

Test Point:
Control. A LOCK_TIMEOUT hint longer than the wait: the client-side MERGE waits for the holder and then updates three rows.

NUM_CLIENTS = 2
C1: UPDATE t28099_t SET k = 99 WHERE id = 2;
C2: MERGE INTO t28099_t USING t28099_u ON (t28099_t.id = t28099_u.id) WHEN MATCHED THEN UPDATE SET t28099_t.k = t28099_t.k + 1000;  -- with the hint LOCK_TIMEOUT(10); waits for C1 and updates 3 rows
C1: COMMIT;  -- 5 seconds after the statement of C2 started
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
C1: DROP VIEW IF EXISTS t28099_v;
C1: DROP VIEW IF EXISTS t28099_v2;
C1: DROP TABLE IF EXISTS t28099_t;
C1: DROP TABLE IF EXISTS t28099_t2;
C1: DROP TABLE IF EXISTS t28099_u;
C1: DROP TABLE IF EXISTS t28099_src;
C1: DROP TABLE IF EXISTS t28099_audit;
C1: DROP TABLE IF EXISTS t28099_x;
C1: CREATE TABLE t28099_t (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t28099_audit (seq INT AUTO_INCREMENT PRIMARY KEY, who INT);
C1: INSERT INTO t28099_t VALUES (1, 10), (2, 20), (3, 30);
C1: CREATE TRIGGER t28099_trg AFTER UPDATE ON t28099_t EXECUTE INSERT INTO t28099_audit (who) VALUES (0);
C1: CREATE TABLE t28099_u (id INT PRIMARY KEY);
C1: INSERT INTO t28099_u VALUES (1), (2), (3);
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* the hint is in a string: the controller strips comments, hints included, from the commands it sends */
C2: PREPARE st28099 FROM 'MERGE /*+ LOCK_TIMEOUT(10) */ INTO t28099_t USING t28099_u ON (t28099_t.id = t28099_u.id) WHEN MATCHED THEN UPDATE SET t28099_t.k = t28099_t.k + 1000';
MC: wait until C2 ready;
C1: UPDATE t28099_t SET k = 99 WHERE id = 2;
MC: wait until C1 ready;
C2: EXECUTE st28099;
/* longer than the hint: a statement that ignores the hint is still waiting when C1 ends */
MC: sleep 5;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 1010), (2, 1099), (3, 1030) */
C1: SELECT id, k FROM t28099_t ORDER BY id;
MC: wait until C1 ready;
/* expect 4: one for C1, three for C2 */
C1: SELECT COUNT(*) FROM t28099_audit;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
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
