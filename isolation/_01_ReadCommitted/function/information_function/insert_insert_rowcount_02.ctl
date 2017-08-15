/*
Test Case: insert & insert 
Priority: 1
Reference case:
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC INSERT/INSERT scenarios if using information function ROW_COUNT in the query 

Test Scenario:
C1 insert, C2 insert
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1,C2 insert an unique index to identical value 
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait
2) C1 instances will be inserted, the row_count requested by C1 will be retrieved based on its own snapshot(session) 
   C2 instances won't be inserted since duplicate key violation, row_count should be 0 

NUM_CLIENTS = 2
C1: insert into table t1; select row_count from table t1;
C2: insert into table t1; select row_count from table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t1 VALUES(8,'xyz','H');
MC: wait until C1 ready;
C2: INSERT INTO t1 VALUES(8,'abc','H');
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 1 is selected */
C1: SELECT ROW_COUNT();
C1: commit;
/* expect: a duplicate key error message should generated once C2 ready, C2 select - row_count = -1 is selected */
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;