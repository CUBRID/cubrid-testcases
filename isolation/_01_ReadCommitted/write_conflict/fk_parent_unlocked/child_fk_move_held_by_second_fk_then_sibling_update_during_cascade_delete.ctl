/*
Test Case: fk_parent_unlocked/child_fk_move_held_by_second_fk_then_sibling_update_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction moves child 4 of parent 8 to parent 7 and to another row of a second parent table in one UPDATE.
C2 updates child 4 and waits in the check of its second foreign key for C3, which has deleted a row of the second parent table. While C2 waits, the parent DELETE (ON DELETE CASCADE) of C1 runs. After C3 rolls back, C2 updates the sibling child 2 of the same parent.
The UPDATE of C2 writes the heap record before the index entries and the foreign key checks, so the DELETE of C1 sees C2 as a writer of child 4 and waits for it before it locks any child. The UPDATE of child 2 does not wait, and the two do not deadlock; after the commit of C2 the DELETE removes children 2 and 4.

NUM_CLIENTS = 3
C3: DELETE FROM t27463_parent2 WHERE id = 5;
C2: UPDATE t27463_child SET pid = 7, rid = 5 WHERE id = 4;
C1: DELETE FROM t27463_parent WHERE id = 7;
C3: ROLLBACK;
C2: UPDATE t27463_child SET x = x + 1 WHERE id = 2;
C2: COMMIT;
C1: COMMIT;
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
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: DROP TABLE IF EXISTS t27463_parent2;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_parent2 (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, rid INT, x INT, FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE CASCADE, FOREIGN KEY (rid) REFERENCES t27463_parent2(id));
C1: INSERT INTO t27463_parent VALUES (7,0),(8,0);
C1: INSERT INTO t27463_parent2 VALUES (5,0),(6,0);
C1: INSERT INTO t27463_child VALUES (2,7,6,0),(4,8,6,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: DELETE FROM t27463_parent2 WHERE id = 5;
MC: wait until C3 ready;
C2: UPDATE t27463_child SET pid = 7, rid = 5 WHERE id = 4;
MC: wait until C2 blocked;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
C3: ROLLBACK;
MC: wait until C3 ready;
MC: wait until C2 ready;
C2: UPDATE t27463_child SET x = x + 1 WHERE id = 2;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id=c.pid);
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: DROP TABLE t27463_parent2;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
