/*
Test Case: cascade_moved_child/child_fk_update_away_then_parent_cascade_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A parent DELETE under ON DELETE CASCADE waits for a child that an uncommitted UPDATE moves to another parent. After the move commits, the moved child is kept.

NUM_CLIENTS = 2
C1: UPDATE t27464_child SET pid = 2 WHERE cid = 10;
C2: DELETE FROM t27464_parent WHERE id = 1;
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
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_parent;
C1: CREATE TABLE t27464_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27464_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27464_parent(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27464_child VALUES (10,1,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27464_child SET pid = 2 WHERE cid = 10;
MC: wait until C1 ready;
C2: DELETE FROM t27464_parent WHERE id = 1;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_parent;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE cid=10 AND pid=2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE NOT EXISTS (SELECT 1 FROM t27464_parent p WHERE p.id=c.pid);
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
