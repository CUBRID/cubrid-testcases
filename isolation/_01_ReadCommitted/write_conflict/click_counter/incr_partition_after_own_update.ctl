/*
Test Case: click_counter/incr_partition_after_own_update
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
As incr_after_own_update on a partitioned table, where the click counter locks the row during the scan: another transaction does not see the update or the increment, and a rollback removes both.

NUM_CLIENTS = 2
C1: UPDATE t27034_c SET v=100 WHERE id=1;
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
C2: SELECT v FROM t27034_c WHERE id=1; -- 10
C1: ROLLBACK;
C2: SELECT v FROM t27034_c WHERE id=1; -- 10
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
C1: CREATE TABLE t27034_c (id INT PRIMARY KEY, v INT) PARTITION BY HASH (id) PARTITIONS 2;
C1: INSERT INTO t27034_c VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_c SET v=100 WHERE id=1;
MC: wait until C1 ready;
/* expect 100 */
C1: SELECT INCR(v) FROM t27034_c WHERE id=1;
MC: wait until C1 ready;
/* expect 10: the update and the increment are not committed */
C2: SELECT v FROM t27034_c WHERE id=1;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
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
