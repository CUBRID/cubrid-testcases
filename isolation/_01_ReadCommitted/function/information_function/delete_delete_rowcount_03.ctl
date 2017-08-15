/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC DELETE/DELETE scenarios if using information function ROW_COUNT in the query
and the affected instances are overlapped  

Test Scenario:
C1 delete, C2 delete, the affected instances are overlapped (whole table execution)
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = no, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be deleted, the row_count requested by C1 will be retrieved based on its own snapshot(session) 
   C2 instances won't be deleted since all the instances have been deleted, 
   the row_count requested by C2 will be retrieved after reevaluation 

NUM_CLIENTS = 2
C1: deleted from table t1; select row_count from table t1;
C2: deleted from table t1; select row_count from table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1;
MC: wait until C1 ready;
C2: DELETE FROM t1;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 7 is selected */
C1: SELECT ROW_COUNT();
C1: commit;
/* expect: no instance updated message should be generated once C2 ready, row_count = 0 is selected*/
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;
