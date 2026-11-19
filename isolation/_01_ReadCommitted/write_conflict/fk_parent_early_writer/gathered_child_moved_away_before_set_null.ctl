/*
Test Case: fk_parent_early_writer/gathered_child_moved_away_before_set_null
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A parent DELETE (ON DELETE SET NULL) gathers the children of the key and waits for a transaction that inserted one. Meanwhile another transaction moves one of the gathered children to another parent and commits.
The DELETE re-checks each gathered child under its lock: the moved child keeps its new parent, and the others are set to NULL.

NUM_CLIENTS = 3
C3: INSERT INTO t27463_child VALUES (3, 7, 0);
C1: DELETE FROM t27463_parent WHERE id = 7;
C2: UPDATE t27463_child SET pid = 8 WHERE id = 0;
C2: commit work;
C3: commit work;
C1: commit work;
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
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id) ON DELETE SET NULL);
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_parent VALUES (8, 0);
C1: INSERT INTO t27463_child VALUES (0, 7, 0);
C1: INSERT INTO t27463_child VALUES (1, 7, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: INSERT INTO t27463_child VALUES (3, 7, 0);
MC: wait until C3 ready;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
C2: UPDATE t27463_child SET pid = 8 WHERE id = 0;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 blocked;
C3: commit work;
MC: wait until C3 ready;
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
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
