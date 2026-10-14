/*
Test Case: cbrd_27034_c2h_incr_after_own_insert_heap
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
As c2 on a table without a unique index, where no key lock marks the inserted row as the transaction's: another transaction does not see the row before the commit, and nothing is left after a rollback. Before CBRD-27034, develop included, the increment committed by itself here and the uncommitted row became visible.

NUM_CLIENTS = 2
C1: INSERT INTO t27034_c VALUES (2,10);
C1: SELECT INCR(v) FROM t27034_c WHERE id=2;
C2: SELECT COUNT(*) FROM t27034_c WHERE id=2; -- 0
C1: ROLLBACK;
C2: SELECT COUNT(*) FROM t27034_c WHERE id=2; -- 0
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_c;
C1: CREATE TABLE t27034_c (id INT, v INT);
C1: INSERT INTO t27034_c VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t27034_c VALUES (2,10);
MC: wait until C1 ready;
/* expect 10 */
C1: SELECT INCR(v) FROM t27034_c WHERE id=2;
MC: wait until C1 ready;
/* expect 0: the row is not committed */
C2: SELECT COUNT(*) FROM t27034_c WHERE id=2;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C2: SELECT COUNT(*) FROM t27034_c WHERE id=2;
MC: wait until C2 ready;
/* expect 10 */
C2: SELECT v FROM t27034_c WHERE id=1;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_c;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
