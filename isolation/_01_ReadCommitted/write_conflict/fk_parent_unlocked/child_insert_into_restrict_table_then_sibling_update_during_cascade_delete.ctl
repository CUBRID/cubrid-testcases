/*
Test Case: fk_parent_unlocked/child_insert_into_restrict_table_then_sibling_update_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
Two child tables refer to the parent, the first with ON DELETE CASCADE and the second with ON DELETE RESTRICT. A transaction inserts a row of the second table referring to a parent that has a committed row in the first, and a parent DELETE waits for that INSERT.
The transaction then updates the committed row of the first table. The DELETE waits for the INSERT's transaction before it locks a child of either table, so the UPDATE does not wait and the two do not deadlock; after the commit the DELETE fails on the restrict foreign key and every row stays.

NUM_CLIENTS = 2
C1: INSERT INTO t27463_child_b VALUES (20,1,'n');
C2: DELETE FROM t27463_parent WHERE id = 1;
C1: UPDATE t27463_child SET note = 'y' WHERE cid = 10;
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
C1: DROP TABLE IF EXISTS t27463_child_b;
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27463_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE CASCADE);
C1: CREATE TABLE t27463_child_b (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE RESTRICT);
C1: INSERT INTO t27463_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27463_child VALUES (10,1,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t27463_child_b VALUES (20,1,'n');
MC: wait until C1 ready;
/* expect an error */
C2: DELETE FROM t27463_parent WHERE id = 1;
MC: wait until C2 blocked;
C1: UPDATE t27463_child SET note = 'y' WHERE cid = 10;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child WHERE cid = 10 AND note = 'y';
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child_b;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27463_child_b;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
