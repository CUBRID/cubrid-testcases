/*
Test Case: fk_parent_mark_newcomer/child_insert_after_mark_fails_when_first_writer_rolls_back
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
The foreign key is RESTRICT. A parent DELETE waits for a transaction that inserted a child, and a second transaction inserts a child of the same parent after the DELETE marked the parent key: that INSERT waits on the DELETE, and the DELETE does not wait for it, so the two do not deadlock.
The first child is rolled back, the DELETE succeeds, and the late INSERT fails on the foreign key.

NUM_CLIENTS = 3
C3: INSERT INTO t27463_child VALUES (3, 7, 0);
C1: DELETE FROM t27463_parent WHERE id = 7;
C2: INSERT INTO t27463_child VALUES (4, 7, 0);
C3: rollback work;
C1: commit work;
C2: rollback work;
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
C3: INSERT INTO t27463_child VALUES (3, 7, 0);
MC: wait until C3 ready;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
/* expect an error */
C2: INSERT INTO t27463_child VALUES (4, 7, 0);
MC: wait until C2 blocked;
C3: rollback work;
MC: wait until C3 ready;
MC: wait until C2 blocked;
MC: wait until C1 ready;
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
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
