/*
Test Case: fk_parent_unlocked/child_insert_then_parent_update_during_replace_cascade
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198), CBRD-26664
Author: hgryoo

Test Point:
A transaction inserts a child of a parent and, while a REPLACE of that parent (ON DELETE CASCADE) waits for that child, updates a non-key column of the parent.
The statement gives the parent row back before it waits, as a DELETE does, so the parent UPDATE does not wait and the two do not deadlock; once the child's transaction commits, the REPLACE takes the child with the old row.

NUM_CLIENTS = 2
C1: INSERT INTO t27463_child VALUES (11, 2, 'n');
C2: REPLACE INTO t27463_parent VALUES (2, 'z');
C1: UPDATE t27463_parent SET name = 'y' WHERE id = 2;
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
C1: INSERT INTO t27463_child VALUES (11, 2, 'n');
MC: wait until C1 ready;
C2: REPLACE INTO t27463_parent VALUES (2, 'z');
MC: wait until C2 blocked;
C1: UPDATE t27463_parent SET name = 'y' WHERE id = 2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child WHERE pid = 2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_parent WHERE id = 2 AND name = 'z';
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
