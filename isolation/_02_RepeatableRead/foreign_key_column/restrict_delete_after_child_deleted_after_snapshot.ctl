/*
Test Case: foreign_key_column/restrict_delete_after_child_deleted_after_snapshot
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
Under REPEATABLE READ, another transaction deletes the only child of a parent and commits after the snapshot of the deleting transaction.
The parent DELETE (ON DELETE RESTRICT) finds no child, so it succeeds.

NUM_CLIENTS = 2
C1: SELECT COUNT(*) FROM t27463_parent;
C2: DELETE FROM t27463_child WHERE id = 20;
C2: commit work;
C1: DELETE FROM t27463_parent WHERE id = 8;
C1: commit work;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id));
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_parent VALUES (8, 0);
C1: INSERT INTO t27463_child VALUES (20, 8, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C1 ready;
C2: DELETE FROM t27463_child WHERE id = 20;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
C1: DELETE FROM t27463_parent WHERE id = 8;
MC: wait until C1 ready;
C1: commit work;
MC: wait until C1 ready;

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
