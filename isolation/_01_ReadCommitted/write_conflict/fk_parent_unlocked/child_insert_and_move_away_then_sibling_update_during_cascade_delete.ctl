/*
Test Case: fk_parent_unlocked/child_insert_and_move_away_then_sibling_update_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction inserts a child of a parent that has a committed child and moves it to another parent at once, and a parent DELETE (ON DELETE CASCADE) of the first parent waits for that transaction.
The transaction then updates the committed child. The DELETE waits for the transaction before it locks any child, so the UPDATE does not wait and the two do not deadlock; after the commit the DELETE takes the committed child, and the moved child stays with the other parent.

NUM_CLIENTS = 2
C1: INSERT INTO t27463_child VALUES (20,1,'n');
C1: UPDATE t27463_child SET pid = 2 WHERE cid = 20;
C2: DELETE FROM t27463_parent WHERE id = 1;
C1: UPDATE t27463_child SET note = 'y' WHERE cid = 10;
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
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27463_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE CASCADE);
C1: INSERT INTO t27463_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27463_child VALUES (10,1,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t27463_child VALUES (20,1,'n');
MC: wait until C1 ready;
C1: UPDATE t27463_child SET pid = 2 WHERE cid = 20;
MC: wait until C1 ready;
C2: DELETE FROM t27463_parent WHERE id = 1;
MC: wait until C2 blocked;
C1: UPDATE t27463_child SET note = 'y' WHERE cid = 10;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child WHERE cid = 20 AND pid = 2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id=c.pid);
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
