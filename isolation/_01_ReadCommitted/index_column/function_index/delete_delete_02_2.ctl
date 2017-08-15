/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/function_index/delete_delete_01.ctl/delete_delete_02.ctl
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with function index)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1 where clause uses function index (i.e. index scan), C2 where clause uses unique index (index scan) 
C1 commit, C2 commit
Metrics: data size = small, index = single function index(LEFT) + PK, where clause = simple, DELETE state = single table deletion

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances should be deleted, C2 instances should be deleted after reevaluation

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: delete from table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abcd','A'),(2,'bcde','B'),(3,'bcdefg','C'),(4,'abcdr','D'),(5,'bcdegh','E'),(6,'bcdweq','F'),(7,'abdfg','G');
C1: CREATE INDEX idx_col_left on t1(LEFT(col,4));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LEFT(col,4) IN ('bcde');
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id BETWEEN 4 AND 6;
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows (id=4,6)deleted message should generated once C2 ready, C2 select - id = 4,6 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready; 
/* expect: the instances of id = 2,3,4,5,6 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
