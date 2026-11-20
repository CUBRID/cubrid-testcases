/*
Test Case: fk_parent_mark_newcomer/child_insert_after_mark_fails_on_partitioned_parent
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
The parent is partitioned and its primary key has two columns. A parent DELETE (ON DELETE CASCADE) waits for a transaction that inserted a child, and a second transaction inserts a child of the same parent after the DELETE marked the key in the partition's index: that INSERT waits on the DELETE, and the DELETE does not wait for it.
After the commits the late INSERT fails on the foreign key.

NUM_CLIENTS = 3
C3: INSERT INTO t27463_child VALUES (3, 1, 5);
C1: DELETE FROM t27463_parent WHERE id = 1;
C2: INSERT INTO t27463_child VALUES (4, 1, 5);
C3: commit work;
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
C1: CREATE TABLE t27463_parent (id INT, r INT, v INT, PRIMARY KEY (id, r)) PARTITION BY RANGE (r) (PARTITION p0 VALUES LESS THAN (10), PARTITION p1 VALUES LESS THAN (20));
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, pr INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid, pr) REFERENCES t27463_parent (id, r) ON DELETE CASCADE);
C1: INSERT INTO t27463_parent VALUES (1, 5, 0);
C1: INSERT INTO t27463_child VALUES (0, 1, 5);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: INSERT INTO t27463_child VALUES (3, 1, 5);
MC: wait until C3 ready;
C1: DELETE FROM t27463_parent WHERE id = 1;
MC: wait until C1 blocked;
/* expect an error */
C2: INSERT INTO t27463_child VALUES (4, 1, 5);
MC: wait until C2 blocked;
C3: commit work;
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
C1: SELECT id, r FROM t27463_parent ORDER BY id;
MC: wait until C1 ready;
C1: SELECT id, pid, pr FROM t27463_child ORDER BY id;
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
