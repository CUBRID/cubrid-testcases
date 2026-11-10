/*
Test Case: cascade_enumeration/same_statement_cascade_changes_children_across_batches
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
same_statement_cascade_changes_a_gathered_child with 10001 children, more than one OID buffer of the child scan. Deleting the first child nulls the self reference of the other 10000 through ON DELETE SET NULL. All children are deleted.

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
C1: INSERT INTO t27464_p VALUES (5,1);
C1: INSERT INTO t27464_c VALUES (5,5,1);
C1: INSERT INTO t27464_c (id, a, b) SELECT 100 + LEVEL, 5, 1 FROM db_root CONNECT BY LEVEL <= 10000;
C1: ALTER TABLE t27464_c ADD CONSTRAINT fk_t27464_c_self FOREIGN KEY (a) REFERENCES t27464_c(id) ON DELETE SET NULL;
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
