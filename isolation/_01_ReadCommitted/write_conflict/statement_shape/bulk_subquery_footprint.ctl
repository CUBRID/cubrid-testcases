/*
Test Case: statement_shape/bulk_subquery_footprint
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A bulk DELETE driven by an IN subquery commits and removes every matching row.

NUM_CLIENTS = 1
C1: DELETE FROM t27034_t WHERE k IN (SELECT k FROM t27034_u);
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_u;
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t27034_u (id INT PRIMARY KEY, k INT);
C1: INSERT INTO t27034_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 200;
C1: INSERT INTO t27034_u SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 200;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27034_t WHERE k IN (SELECT k FROM t27034_u);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27034_t;
C1: DROP TABLE t27034_u;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
