/*
Test Case: cascade_moved_child/multicol_fk_child_moved_then_parent_cascade_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The same with a two-column foreign key: the moved child is kept.

NUM_CLIENTS = 2
C1: UPDATE t27464_child SET fb='y' WHERE id=11;
C2: DELETE FROM t27464_father WHERE a=1 AND b='x';
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
C1: CREATE TABLE t27464_father (a INT, b VARCHAR(10), note VARCHAR(20), PRIMARY KEY (a, b));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fa INT, fb VARCHAR(10), FOREIGN KEY (fa, fb) REFERENCES t27464_father(a, b) ON DELETE CASCADE);
C1: INSERT INTO t27464_father VALUES (1,'x','p'),(1,'y','q');
C1: INSERT INTO t27464_child VALUES (10,1,'x'),(11,1,'x');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27464_child SET fb='y' WHERE id=11;
MC: wait until C1 ready;
C2: DELETE FROM t27464_father WHERE a=1 AND b='x';
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id=10;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id=11 AND fa=1 AND fb='y';
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE NOT EXISTS (SELECT 1 FROM t27464_father f WHERE f.a=c.fa AND f.b=c.fb);
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
