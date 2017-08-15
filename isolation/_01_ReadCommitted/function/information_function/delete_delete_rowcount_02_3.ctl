/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/information_function/delete_delete_rowcount_02.ctl
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC DELETE/DELETE scenarios if using information function ROW_COUNT in the query
and the affected instances are overlapped  

Test Scenario:
C1 delete, C2 delete, the affected instances are overlapped (based on where clause)
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1,C2 where clause are on indexes (index scan)
C1 rollback, C2 commit
Metrics: data size = small, index = function index(LENGTH), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances won't be deleted since C1 rollback, the row_count requested by C1 will be retrieved based on its own snapshot(session) 
   C2 instances will be deleted, the row_count requested by C2 will be retrieved after reevaluation 

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
C1: INSERT INTO t1 VALUES(1,'a','A'),(2,'bb','B'),(3,'ccc','C'),(4,'dddd','D'),(5,'eeeee','E'),(6,'fff','F'),(7,'gg','G');
C1: CREATE INDEX idx_col_length on t1(LENGTH(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LENGTH(col) >= 4;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE LENGTH(col) IN (3,5);
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 2 is selected (id = 4,5) */
C1: SELECT ROW_COUNT();
C1: commit;
/* expect: 2 rows (id=3,6)deleted message should be generated once C2 ready, row_count = 2 is selected*/
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;

