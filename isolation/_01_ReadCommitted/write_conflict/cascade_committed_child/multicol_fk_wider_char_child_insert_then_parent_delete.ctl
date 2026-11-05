/*
Test Case: cascade_committed_child/multicol_fk_wider_char_child_insert_then_parent_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A two-column foreign key whose CHAR(8) column refers to a CHAR(4) primary key column: the child committed during the wait is deleted.

NUM_CLIENTS = 2
C2: INSERT INTO t27464_child VALUES (10,1,'x');
C1: DELETE FROM t27464_father WHERE a=1;
C2: COMMIT;
C1: COMMIT;
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
C1: CREATE TABLE t27464_father (a INT, b CHAR(4), note VARCHAR(20), PRIMARY KEY (a, b));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fa INT, fb CHAR(8), FOREIGN KEY (fa, fb) REFERENCES t27464_father(a, b) ON DELETE CASCADE);
C1: INSERT INTO t27464_father VALUES (1,'x','p'),(2,'y','q');
C1: INSERT INTO t27464_child VALUES (1,2,'y');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27464_child VALUES (10,1,'x');
MC: wait until C2 ready;
C1: DELETE FROM t27464_father WHERE a=1;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id=10;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child;
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
