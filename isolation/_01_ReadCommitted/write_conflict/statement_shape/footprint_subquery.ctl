/*
Test Case: statement_shape/footprint_subquery
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A DELETE with an EXISTS subquery is rolled back while another session counts: the data is unchanged.

NUM_CLIENTS = 2
C1: DELETE FROM t27034_t WHERE EXISTS (SELECT 1 FROM t27034_s WHERE t27034_s.id = t27034_t.id);
C2: SELECT COUNT(*) FROM t27034_t;
C1: ROLLBACK;
C2: SELECT COUNT(*) FROM t27034_t;
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
C1: DROP TABLE IF EXISTS t27034_s;
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t27034_s (id INT PRIMARY KEY);
C1: INSERT INTO t27034_t SELECT ROWNUM, ROWNUM FROM db_class x, db_class y LIMIT 300;
C1: INSERT INTO t27034_s SELECT ROWNUM FROM db_class x, db_class y LIMIT 200;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27034_t WHERE EXISTS (SELECT 1 FROM t27034_s WHERE t27034_s.id = t27034_t.id);
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 300 */
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
/* expect 200 */
C2: SELECT COUNT(*) FROM t27034_s;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_t;
C1: DROP TABLE t27034_s;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
