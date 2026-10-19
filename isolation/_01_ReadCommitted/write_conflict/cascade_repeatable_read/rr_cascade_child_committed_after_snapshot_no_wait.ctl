/*
Test Case: cascade_repeatable_read/rr_cascade_child_committed_after_snapshot_no_wait
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The same without a wait: the child committed after the REPEATABLE READ snapshot makes the CASCADE DELETE fail with a serialization conflict.

NUM_CLIENTS = 2
C1: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
C1: SELECT COUNT(*) FROM t27464_father;
C2: INSERT INTO t27464_child VALUES (10, 2);
C2: COMMIT;
C1: DELETE FROM t27464_father WHERE id=2;
C1: ROLLBACK;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_father;
C1: CREATE TABLE t27464_father (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27464_father(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_father VALUES (1,'a'),(2,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
MC: wait until C1 ready;
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
C2: INSERT INTO t27464_child VALUES (10, 2);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: DELETE FROM t27464_father WHERE id=2;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
C2: SELECT COUNT(*) FROM t27464_father;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27464_child;
MC: wait until C2 ready;
/* expect 0 */
C2: SELECT COUNT(*) FROM t27464_child c WHERE NOT EXISTS (SELECT 1 FROM t27464_father f WHERE f.id=c.fid);
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
