/*
Test Case: fk_parent_restrict_check/restrict_child_deleted_then_cascade_child_updated
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
Two child tables refer to the parent, the first with ON DELETE CASCADE and the second with RESTRICT. A transaction deletes the committed child in the RESTRICT table, and a parent DELETE waits for that transaction before it locks a child of either table, so the transaction's UPDATE of the CASCADE child does not wait and the two do not deadlock.
After the commit the RESTRICT table has no child, and the DELETE takes the CASCADE child.

NUM_CLIENTS = 2
C2: DELETE FROM t27463_child2 WHERE id = 3;
C1: DELETE FROM t27463_parent WHERE id = 7;
C2: UPDATE t27463_child SET x = 1 WHERE id = 0;
C2: commit work;
C1: commit work;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_child2;
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id) ON DELETE CASCADE);
C1: CREATE TABLE t27463_child2 (id INT PRIMARY KEY, pid INT, CONSTRAINT fk_t27463_child2 FOREIGN KEY (pid) REFERENCES t27463_parent (id));
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_child VALUES (0, 7, 0);
C1: INSERT INTO t27463_child2 VALUES (3, 7);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: DELETE FROM t27463_child2 WHERE id = 3;
MC: wait until C2 ready;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
C2: UPDATE t27463_child SET x = 1 WHERE id = 0;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
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
C1: SELECT id, pid FROM t27463_child2 ORDER BY id;
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27463_child2;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
