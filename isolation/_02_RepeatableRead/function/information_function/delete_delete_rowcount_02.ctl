/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray
Isolation Level: Repeatable Read
Function: ROW_COUNT()

Test Plan: 
Test MVCC DELETE/DELETE scenarios if using information function ROW_COUNT in the query 

Test Scenario:
C1 delete, C2 delete, the instances are overlapped (based on where clause)
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 C2 can only see its own changes (Visibility Test)
3) C1 instances will be inserted, the row_count requested by C1 will be retrieved based on its own snapshot(session) 
   C2 instances will be inserted, the row_count requested by C2 will be retrieved based on its own snapshot(session) 

NUM_CLIENTS = 2
C1: insert into table t1; select row_count from table t1;
C2: insert into table t1; select row_count from table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 3 and id <= 4;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id >= 4 and id <= 5;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 2 is retrieved */
C1: SELECT ROW_COUNT();
C1: commit;
/* expect: 'Serializable conflict due to concurrent update' message, C2 select - row_count = -1 is retrieved */
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;