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
C1,C2 where clause uses each of multiple indexes respectively (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple filtered indexes, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be deleted, the row_count requested by C1 will be retrieved based on its own snapshot(session) 
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
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: CREATE INDEX idx_id on t1(id) WHERE id >= 3 and id <= 4;
C1: CREATE INDEX idx_col on t1(col) WHERE col IN ('def','ghi');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 3 and id <= 4 USING INDEX idx_id(+);
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE col = 'ghi' or col = 'def' USING INDEX idx_col(+);
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 2 is selected */
C1: SELECT ROW_COUNT();
C1: commit;
/* expect: 1 rows (id=2)deleted message should be generated once C2 ready, row_count = 1 is selected*/
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;

