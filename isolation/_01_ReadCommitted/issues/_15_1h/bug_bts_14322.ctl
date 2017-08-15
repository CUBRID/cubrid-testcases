/*
Issue Case: CUBRIDSUS-14322
Priority: 1
Reference case:
Isolation Read Committed
Author: Ray

Test Plan: 
Test the scenario that the select(incr/decr) should read the re-evaluated data from other committed transactions

Test Scenario:
C1 update, C2 select incr, the affected rows are overlapped (based on where clause)
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2(select) needs to be blocked wait for C1 (locking)
2) C2 could see the C1 changes (read committed)
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* Test point1: update with select incr */
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT Unique, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET read_count = 0 WHERE id = 1;
MC: wait until C1 ready;
C2: SELECT INCR(read_count), t1.* FROM t1 WHERE read_count = 3; 
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: select * from t1 order by 1,2; 
C1: commit;
/* expect: no data is selected after C2 unblocked */
MC: wait until C2 ready;
C2: commit;

/* Test point2: delete with select incr */
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT Unique, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1;
MC: wait until C1 ready;
C2: SELECT INCR(read_count), t1.* FROM t1 WHERE read_count = 3;
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: commit;
/* expect: no data is selected after C2 unblocked */
MC: wait until C2 ready;
C2: commit;

C1: quit;
C2: quit;