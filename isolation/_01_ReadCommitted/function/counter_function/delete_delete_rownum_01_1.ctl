/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/counter_function/delete_delete_(@newincr:=@newincr+1)_01.ctl
Author: Ray
Function: ROWNUM(INST_NUM)

Test Plan: 
Test MVCC DELETE scenarios (locks - X_LOCK on instance) if using ROWNUM function (ROWNUM/INST_NUM) in delete queries where clause,
and the affected rows are not overlapped

Test Scenario:
C1 delete, C2 delete, the selected rows are not overlapped (based on where clause)
C1,C2 use ROWNUM and index column in their where clauses
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes(PK + Composite index), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) All the instances of C1 and C2 will be deleted

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: delete from table t1;
C3: select from table t1; C3 is used to check the updated result  
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
C1: CREATE INDEX idx_col_tag on t1(col,tag);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id IN (1,3,5) and ROWNUM >= 2;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE id > 5 and ROWNUM = 2; 
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 3,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 7 is deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 3,5,7 are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 3,5,7 are deleted */
C3: select * from t1 order by 1,2;
C3: commit;

MC: wait until C3 ready;
C1: quit;
C2: quit;
C3: quit;

