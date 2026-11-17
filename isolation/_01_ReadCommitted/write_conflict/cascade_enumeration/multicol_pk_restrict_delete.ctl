/*
Test Case: cascade_enumeration/multicol_pk_restrict_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A two-column primary key under a RESTRICT foreign key only: the parent without children is deleted and the DELETE of the parent with a child fails on the foreign key.

NUM_CLIENTS = 1
C1: DELETE FROM t27464_father WHERE a=1 AND b='y';
C1: DELETE FROM t27464_father WHERE a=1 AND b='x';
C1: DELETE FROM t27464_father WHERE a=2;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_father;
C1: CREATE TABLE t27464_father (a INT, b VARCHAR(10), note VARCHAR(20), PRIMARY KEY (a, b));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fa INT, fb VARCHAR(10), FOREIGN KEY (fa, fb) REFERENCES t27464_father(a, b) ON DELETE RESTRICT);
C1: INSERT INTO t27464_father VALUES (1,'x','p'),(1,'y','q'),(2,'x','r');
C1: INSERT INTO t27464_child VALUES (10,1,'x');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27464_father WHERE a=1 AND b='y';
MC: wait until C1 ready;
C1: DELETE FROM t27464_father WHERE a=1 AND b='x';
MC: wait until C1 ready;
C1: DELETE FROM t27464_father WHERE a=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_father WHERE a=1 AND b='x';
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
