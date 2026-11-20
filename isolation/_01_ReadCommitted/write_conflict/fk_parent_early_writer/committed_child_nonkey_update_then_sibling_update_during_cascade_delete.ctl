/*
Test Case: fk_parent_early_writer/committed_child_nonkey_update_then_sibling_update_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction updates a column of a committed child that is not its foreign key. A parent DELETE (ON DELETE CASCADE) waits for that transaction before it locks any child, so the transaction's UPDATE of a sibling does not wait and the two do not deadlock.
After the commit the DELETE takes both children.

NUM_CLIENTS = 2
C1: UPDATE t27463_child SET x = 5 WHERE id = 2;
C2: DELETE FROM t27463_parent WHERE id = 7;
C1: UPDATE t27463_child SET x = 1 WHERE id = 1;
C1: commit work;
C2: commit work;
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
C1: INSERT INTO t27463_child VALUES (1, 7, 0);
C1: INSERT INTO t27463_child VALUES (2, 7, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27463_child SET x = 5 WHERE id = 2;
MC: wait until C1 ready;
C2: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C2 blocked;
C1: UPDATE t27463_child SET x = 1 WHERE id = 1;
MC: wait until C1 ready;
C1: commit work;
MC: wait until C1 ready;
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
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
