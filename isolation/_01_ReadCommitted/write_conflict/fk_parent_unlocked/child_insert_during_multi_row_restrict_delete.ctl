/*
Test Case: fk_parent_unlocked/child_insert_during_multi_row_restrict_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A parent DELETE (ON DELETE RESTRICT) of two rows has locked the first and waits on the second, which another transaction updated. A child INSERT that references the first parent does not wait, since the foreign key check takes no lock on the parent row and the DELETE has not marked the parent key yet. When the DELETE goes on, it waits for the uncommitted child and then fails on the foreign key. No orphan is left.

NUM_CLIENTS = 3
C3: UPDATE t27463_parent SET name = 'x' WHERE id = 2;
C1: DELETE FROM t27463_parent WHERE id IN (1, 2); -- blocks on row 2
C2: INSERT INTO t27463_child VALUES (10, 1, 'c');
C3: COMMIT;
C1: (waits for C2)
C2: COMMIT;
C1: (released, fails)
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
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27463_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE RESTRICT);
C1: INSERT INTO t27463_parent VALUES (1,'a'),(2,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: UPDATE t27463_parent SET name = 'x' WHERE id = 2;
MC: wait until C3 ready;
C1: DELETE FROM t27463_parent WHERE id IN (1, 2);
MC: wait until C1 blocked;
C2: INSERT INTO t27463_child VALUES (10, 1, 'c');
MC: wait until C2 ready;
C3: COMMIT;
MC: wait until C3 ready;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id = c.pid);
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
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
