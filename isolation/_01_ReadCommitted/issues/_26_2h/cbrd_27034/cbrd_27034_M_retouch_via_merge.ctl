/*
Test Case: cbrd_27034_M_retouch_via_merge
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A server-executed MERGE updates a row its transaction updated earlier while another transaction waits for it: no deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C1: MERGE INTO t27034_t USING (SELECT 1 AS id FROM db_root) s ON (t27034_t.id = s.id) WHEN MATCHED THEN UPDATE SET t27034_t.v = t27034_t.v + 1;
C1: COMMIT;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C1: MERGE INTO t27034_t USING (SELECT 1 AS id FROM db_root) s ON (t27034_t.id = s.id) WHEN MATCHED THEN UPDATE SET t27034_t.v = t27034_t.v + 1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 3 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
