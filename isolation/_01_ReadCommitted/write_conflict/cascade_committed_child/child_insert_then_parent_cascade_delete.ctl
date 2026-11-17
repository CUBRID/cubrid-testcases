/*
Test Case: cascade_committed_child/child_insert_then_parent_cascade_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A parent DELETE under ON DELETE CASCADE waits for an uncommitted child INSERT. Once the child commits, the DELETE deletes it too, so no orphan is left.

NUM_CLIENTS = 2
C2: INSERT INTO t27464_child VALUES (10, 2);
C1: DELETE FROM t27464_father WHERE id=2;
C2: COMMIT;
C1: COMMIT;
C2: SELECT COUNT(*) FROM t27464_child;
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
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_father;
C1: CREATE TABLE t27464_father (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27464_father(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_father VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27464_child VALUES (1, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27464_child VALUES (10, 2);
MC: wait until C2 ready;
C1: DELETE FROM t27464_father WHERE id=2;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27464_child;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE fid=2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child;
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
