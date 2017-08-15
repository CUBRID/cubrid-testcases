/*
Test Case: delete & update 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/function_index/basic_sql/delete_update_02.ctl
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with filtered index)
C1 try to delete a unique index that C2 try to update to

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 try to delete an unique index that C2 try to update to 
C1 where clause uses function index (index scan), C2 where clause uses the unique index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single function index(LEFT) + PK, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances should be deleted since C1 commit
   C2 instances should be updated since the duplicate key has been removed (after reevaluation)

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: update table t1;  
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
C2: UPDATE t1 SET id = 2 WHERE id = 4 USING INDEX idx_col_left;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=4)updated message, C2 select - id = 4 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 2,3,5 are deleted, id = 4 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
