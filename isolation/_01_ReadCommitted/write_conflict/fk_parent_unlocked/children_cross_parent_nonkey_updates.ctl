/*
Test Case: fk_parent_unlocked/children_cross_parent_nonkey_updates
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198), CBRD-26664
Author: hgryoo

Test Point:
Two transactions each insert a child of a different parent and then update a non-key column of the other one's parent. The child INSERTs hold no parent row lock, so neither UPDATE waits and no deadlock cycle closes: all three children and both updates remain.

NUM_CLIENTS = 2
C1: INSERT INTO t27463_child VALUES (21, 2, 'c');
C2: INSERT INTO t27463_child VALUES (20, 1, 'c');
C1: UPDATE t27463_parent SET name = 'new' WHERE id = 1;
C2: UPDATE t27463_parent SET name = 'new' WHERE id = 2;
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
C1: INSERT INTO t27463_child VALUES (21, 2, 'c');
MC: wait until C1 ready;
C2: INSERT INTO t27463_child VALUES (20, 1, 'c');
MC: wait until C2 ready;
C1: UPDATE t27463_parent SET name = 'new' WHERE id = 1;
MC: wait until C1 ready;
C2: UPDATE t27463_parent SET name = 'new' WHERE id = 2;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 3 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27463_parent WHERE name='new';
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id=c.pid);
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
