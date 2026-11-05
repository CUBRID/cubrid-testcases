/*
Test Case: cascade_committed_child/partitioned_child_insert_then_parent_cascade_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A HASH-partitioned child table: of the children of the deleted parent, the one inserted during the wait is deleted and the one moved to another parent during the wait is kept.

NUM_CLIENTS = 2
C2: INSERT INTO t27464_child VALUES (10, 2);
C2: UPDATE t27464_child SET fid=1 WHERE id=3;
C1: DELETE FROM t27464_father WHERE id=2;
C2: COMMIT;
C1: COMMIT;
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
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27464_father(id) ON DELETE CASCADE) PARTITION BY HASH (id) PARTITIONS 3;
C1: INSERT INTO t27464_father VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27464_child VALUES (1,1),(2,2),(3,2),(4,1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27464_child VALUES (10, 2);
MC: wait until C2 ready;
C2: UPDATE t27464_child SET fid=1 WHERE id=3;
MC: wait until C2 ready;
C1: DELETE FROM t27464_father WHERE id=2;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE fid=2;
MC: wait until C1 ready;
/* expect 3 */
C1: SELECT COUNT(*) FROM t27464_child;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id=3 AND fid=1;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE NOT EXISTS (SELECT 1 FROM t27464_father f WHERE f.id=c.fid);
MC: wait until C1 ready;

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
