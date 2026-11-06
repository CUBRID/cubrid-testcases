/*
Test Case: fk_parent_restrict_check/committed_child_behind_inserting_entry_fails_restrict
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
The foreign key is RESTRICT. In the key of the child index, an entry another transaction is still inserting comes before a committed child. The parent DELETE looks past the entry being inserted and fails on the committed child at once, without waiting for the inserter.
After the DELETE's transaction rolls back, the inserter adds another child and commits.

NUM_CLIENTS = 3
C2: INSERT INTO t27463_child VALUES (3, 7, 0);
C3: INSERT INTO t27463_child VALUES (1, 7, 0);
C3: commit work;
C1: DELETE FROM t27463_parent WHERE id = 7;
C1: rollback work;
C2: INSERT INTO t27463_child VALUES (4, 7, 0);
C2: commit work;
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
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id));
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_parent VALUES (8, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27463_child VALUES (3, 7, 0);
MC: wait until C2 ready;
C3: INSERT INTO t27463_child VALUES (1, 7, 0);
MC: wait until C3 ready;
C3: commit work;
MC: wait until C3 ready;
/* expect an error */
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 ready;
C1: rollback work;
MC: wait until C1 ready;
C2: INSERT INTO t27463_child VALUES (4, 7, 0);
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
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
