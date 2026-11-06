/*
Test Case: cascade_moved_child/setnull_update_moved_child_across_batches
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
setnull_update_moved_last_of_many_children with 20000 children, more than one OID buffer of the child scan, so the parent key UPDATE under ON UPDATE SET NULL keeps more children than one buffer holds before it acts on them. The last child is moved to another parent by an uncommitted UPDATE, and the parent key UPDATE waits on its lock. 19999 children are nulled and the moved one keeps its new parent.

NUM_CLIENTS = 2
C2: UPDATE t27464_child SET pid=2 WHERE cid=20000;
C1: UPDATE t27464_parent SET id=3 WHERE id=1;
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
C1: DROP TABLE IF EXISTS t27464_parent;
C1: CREATE TABLE t27464_parent (id INT PRIMARY KEY);
C1: CREATE TABLE t27464_child (cid INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27464_parent(id) ON UPDATE SET NULL);
C1: INSERT INTO t27464_parent VALUES (1),(2);
C1: INSERT INTO t27464_child (cid, pid) SELECT LEVEL, 1 FROM db_root CONNECT BY LEVEL <= 20000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27464_child SET pid=2 WHERE cid=20000;
MC: wait until C2 ready;
C1: UPDATE t27464_parent SET id=3 WHERE id=1;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE pid=1;
MC: wait until C1 ready;
/* expect 19999 */
C1: SELECT COUNT(*) FROM t27464_child WHERE pid IS NULL;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE cid=20000 AND pid=2;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27464_parent p WHERE p.id=c.pid);
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
