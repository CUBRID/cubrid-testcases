/*
Test Case: cascade_enumeration/parent_locked_child_insert_fails_on_fk_not_deadlock
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A child INSERT is blocked on its foreign key check by a parent row another transaction updated in an earlier statement; that transaction then deletes the parent with CASCADE. The enumeration does not wait for the child still being inserted, so there is no deadlock: the INSERT fails on the foreign key and the child it inserted earlier survives its COMMIT.

NUM_CLIENTS = 2
C2: INSERT INTO t27464_child VALUES (5, 1);
C1: UPDATE t27464_father SET note='x' WHERE id=2;
C2: INSERT INTO t27464_child VALUES (10, 2);
C1: DELETE FROM t27464_father WHERE id=2;
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
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_father;
C1: CREATE TABLE t27464_father (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27464_father(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_father VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27464_child VALUES (1, 1), (2, 2);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27464_child VALUES (5, 1);
MC: wait until C2 ready;
C1: UPDATE t27464_father SET note='x' WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO t27464_child VALUES (10, 2);
MC: wait until C2 blocked;
C1: DELETE FROM t27464_father WHERE id=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id=5;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id=10;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27464_child;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE NOT EXISTS (SELECT 1 FROM t27464_father f WHERE f.id=c.fid);
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
