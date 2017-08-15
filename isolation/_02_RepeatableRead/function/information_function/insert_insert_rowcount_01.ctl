/*
Test Case: insert & insert 
Priority: 1
Reference case:
Author: Ray
Isolation Level: Repeatable Read
Function: ROW_COUNT()

Test Plan: 
Test MVCC INSERT/INSERT scenarios if using information function ROW_COUNT in the query 

Test Scenario:
C1 insert, C2 insert
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait (Locking Test)
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
C1: INSERT INTO t1 VALUES(8,'xyz','H'),(9,'def','I');
MC: wait until C1 ready;
C2: INSERT INTO t1 VALUES(10,'xxx','J');
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - row_count = 2 is retrieved */
C1: SELECT ROW_COUNT();
MC: wait until C1 ready;
/* expect: C2 select - row_count = 1 is retrieved */
C2: SELECT ROW_COUNT();
C1: commit;
/* expect: C2 select - row_count = -1 is retrieved */
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;