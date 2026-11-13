/*
Test Case: fk_parent_early_writer/child_delete_rolled_back_to_savepoint_then_updated
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction deletes a committed child after a savepoint, and a parent DELETE (ON DELETE CASCADE) waits for it. The transaction rolls back to the savepoint and updates the child: the parent DELETE holds no lock on the child while it waits, so the UPDATE does not wait and the two do not deadlock.
After the commit the DELETE takes the child.

NUM_CLIENTS = 2
C1: SAVEPOINT s1;
C1: DELETE FROM t27463_child WHERE id = 1;
C2: DELETE FROM t27463_parent WHERE id = 7;
C1: ROLLBACK TO SAVEPOINT s1;
C1: UPDATE t27463_child SET x = 1 WHERE id = 1;
C1: commit work;
C2: commit work;
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
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id) ON DELETE CASCADE);
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_child VALUES (1, 7, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SAVEPOINT s1;
MC: wait until C1 ready;
C1: DELETE FROM t27463_child WHERE id = 1;
MC: wait until C1 ready;
C2: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C2 blocked;
C1: ROLLBACK TO SAVEPOINT s1;
MC: wait until C1 ready;
C1: UPDATE t27463_child SET x = 1 WHERE id = 1;
MC: wait until C1 ready;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;

/* expected end state */
C1: SELECT id, v FROM t27463_parent ORDER BY id;
MC: wait until C1 ready;
C1: SELECT id, pid, x FROM t27463_child ORDER BY id;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id = c.pid);
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
