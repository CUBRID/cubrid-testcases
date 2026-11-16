/*
Test Case: cascade_enumeration/same_statement_cascade_changes_a_gathered_child
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A cascade of the same statement nulls the self reference of a child the DELETE already gathered; both children are deleted.

NUM_CLIENTS = 1
C1: DELETE FROM t27464_p WHERE x=5;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_c;
C1: DROP TABLE IF EXISTS t27464_p;
C1: CREATE TABLE t27464_p (x INT, y INT, PRIMARY KEY (x, y));
C1: CREATE TABLE t27464_c (id INT PRIMARY KEY, a INT, b INT, FOREIGN KEY (a, b) REFERENCES t27464_p(x, y) ON DELETE CASCADE);
C1: ALTER TABLE t27464_c ADD CONSTRAINT fk_c_self FOREIGN KEY (a) REFERENCES t27464_c(id) ON DELETE SET NULL;
C1: INSERT INTO t27464_p VALUES (5, 1);
C1: INSERT INTO t27464_c VALUES (5, 5, 1);
C1: INSERT INTO t27464_c VALUES (6, 5, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27464_p WHERE x=5;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_p;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_c;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27464_c;
C1: DROP TABLE t27464_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
