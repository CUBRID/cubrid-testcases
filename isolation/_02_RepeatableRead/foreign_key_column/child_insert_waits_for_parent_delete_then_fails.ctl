/*
Test Case: foreign_key_column/child_insert_waits_for_parent_delete_then_fails
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
Under REPEATABLE READ, a child INSERT meets a parent that another transaction deleted and has not committed, and waits for that transaction.
The DELETE commits, so the INSERT fails on the foreign key, although its snapshot still sees the parent.

NUM_CLIENTS = 2
C2: SELECT COUNT(*) FROM t27463_parent;
C1: DELETE FROM t27463_parent WHERE id = 8;
C2: INSERT INTO t27463_child VALUES (21, 8, 0);
C1: commit work;
C2: rollback work;
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
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C2 ready;
C1: DELETE FROM t27463_parent WHERE id = 8;
MC: wait until C1 ready;
/* expect an error */
C2: INSERT INTO t27463_child VALUES (21, 8, 0);
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: rollback work;
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
