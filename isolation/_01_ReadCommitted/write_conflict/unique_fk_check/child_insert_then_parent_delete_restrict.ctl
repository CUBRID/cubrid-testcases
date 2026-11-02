/*
Test Case: unique_fk_check/child_insert_then_parent_delete_restrict
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A RESTRICT DELETE of a parent with an uncommitted child INSERT waits, and fails on RESTRICT once the child commits.

NUM_CLIENTS = 2
C2: INSERT INTO t27034_child VALUES (10, 2);
C1: DELETE FROM t27034_father WHERE id=2; -- blocks
C2: COMMIT;
C1: (released, fails)
C1: ROLLBACK;
C2: SELECT COUNT(*) FROM t27034_child;
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
C1: DROP TABLE IF EXISTS t27034_child;
C1: DROP TABLE IF EXISTS t27034_father;
C1: CREATE TABLE t27034_father (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27034_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27034_father(id));
C1: INSERT INTO t27034_father VALUES (1,'a'),(2,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27034_child VALUES (10, 2);
MC: wait until C2 ready;
C1: DELETE FROM t27034_father WHERE id=2;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27034_child;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_child WHERE fid=2;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27034_father;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_child c WHERE NOT EXISTS (SELECT 1 FROM t27034_father f WHERE f.id=c.fid);
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_child;
C1: DROP TABLE t27034_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
