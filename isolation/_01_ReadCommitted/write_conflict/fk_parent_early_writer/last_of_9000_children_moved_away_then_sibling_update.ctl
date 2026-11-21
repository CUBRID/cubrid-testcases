/*
Test Case: fk_parent_early_writer/last_of_9000_children_moved_away_then_sibling_update
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A parent has 9,000 children, more than one OID buffer of the child scan holds. A transaction moves the last child to another parent, and a parent DELETE (ON DELETE CASCADE) waits for that transaction before it locks any child, so the transaction's UPDATE of the first child does not wait and the two do not deadlock.
After the commit the DELETE takes the 8,999 children, and the moved child stays with its new parent.

NUM_CLIENTS = 2
C2: UPDATE t27463_child SET pid = 8 WHERE id = 9000;
C1: DELETE FROM t27463_parent WHERE id = 7;
C2: UPDATE t27463_child SET x = 1 WHERE id = 1;
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
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id) ON DELETE CASCADE);
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_parent VALUES (8, 0);
C1: INSERT INTO t27463_child SELECT LEVEL, 7, 0 FROM db_root CONNECT BY LEVEL <= 9000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27463_child SET pid = 8 WHERE id = 9000;
MC: wait until C2 ready;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
C2: UPDATE t27463_child SET x = 1 WHERE id = 1;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: commit work;
MC: wait until C1 ready;

/* expected end state */
C1: SELECT id, v FROM t27463_parent ORDER BY id;
MC: wait until C1 ready;
C1: SELECT COUNT(*), SUM(x) FROM t27463_child;
MC: wait until C1 ready;
C1: SELECT id, pid FROM t27463_child WHERE id IN (1, 9000, 100000) ORDER BY id;
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
