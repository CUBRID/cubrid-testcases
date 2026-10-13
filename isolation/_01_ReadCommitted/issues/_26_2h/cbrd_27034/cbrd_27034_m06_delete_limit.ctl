/*
Test Case: cbrd_27034_m06_delete_limit
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A DELETE with LIMIT, then rolled back: no assertion fires and 300 rows remain.

NUM_CLIENTS = 1
C1: DELETE FROM t27034_t WHERE id <= 200 LIMIT 100;
C1: ROLLBACK;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t SELECT ROWNUM, 0 FROM db_class a, db_class b LIMIT 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27034_t WHERE id <= 200 LIMIT 100;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 300 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
