/*
Test Case: click_counter/incr_own_row_under_waiter_rollback
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
As incr_own_row_under_waiter, but the transaction rolls back: no deadlock, and the increment goes with the update, leaving only the waiter's update.

NUM_CLIENTS = 2
C1: UPDATE t27034_c SET v=v+1 WHERE id=1;
C2: UPDATE t27034_c SET v=v+1 WHERE id=1; -- blocks
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
C1: ROLLBACK;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27034_c;
C1: CREATE TABLE t27034_c (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_c VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_c SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_c SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
/* expect 11 */
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 11 */
C1: SELECT v FROM t27034_c WHERE id=1;
MC: wait until C1 ready;

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
