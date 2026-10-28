/*
Test Case: foreign_key_column/child_update_and_insert_then_parent_update_during_restrict_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
In REPEATABLE READ a transaction updates a non-key column of a committed child, which keeps that row locked to commit, and inserts a second child of the same parent. A parent DELETE (ON DELETE RESTRICT) then waits for that transaction. The committed child comes first in the key, but its row is still locked, so the DELETE waits for the transaction before it holds the parent row. The transaction's UPDATE of the parent does not wait for the DELETE and the two do not deadlock; once the transaction commits, the DELETE fails on the parent row the transaction changed.

NUM_CLIENTS = 2
C1: UPDATE t27463_child SET note = 'x' WHERE cid = 10;
C1: INSERT INTO t27463_child VALUES (11, 1, 'z');
C2: DELETE FROM t27463_parent WHERE id = 1;
C1: UPDATE t27463_parent SET name = 'y' WHERE id = 1;
C1: COMMIT;
C2: COMMIT;
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
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27463_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE RESTRICT);
C1: INSERT INTO t27463_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27463_child VALUES (10,1,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27463_child SET note = 'x' WHERE cid = 10;
MC: wait until C1 ready;
C1: INSERT INTO t27463_child VALUES (11, 1, 'z');
MC: wait until C1 ready;
C2: DELETE FROM t27463_parent WHERE id = 1;
MC: wait until C2 blocked;
C1: UPDATE t27463_parent SET name = 'y' WHERE id = 1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect y */
C1: SELECT name FROM t27463_parent WHERE id = 1;
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
