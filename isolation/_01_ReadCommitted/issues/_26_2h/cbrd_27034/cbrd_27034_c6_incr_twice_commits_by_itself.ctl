/*
Test Case: cbrd_27034_c6_incr_twice_commits_by_itself
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Control: a second INCR on a row only the first INCR touched still commits by itself, since the first increment's sub-transaction is no longer the transaction's.

NUM_CLIENTS = 2
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
C2: SELECT v FROM t27034_c WHERE id=1; -- 12
C1: ROLLBACK;
C2: SELECT v FROM t27034_c WHERE id=1; -- 12
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
C1: CREATE TABLE t27034_c (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_c VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expect 10 */
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
MC: wait until C1 ready;
/* expect 11 */
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
MC: wait until C1 ready;
/* expect 12: both increments are already committed */
C2: SELECT v FROM t27034_c WHERE id=1;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 12 */
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
