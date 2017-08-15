/*
Test Case: delete & update 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/function_index/basic_sql/delete_update_01.ctl
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with function index)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 where clause uses function index(index) , C2 where clause doesn't use filtered index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = single function index(LENGTH), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be deleted, C2 instances should be updated

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'a','A'),(2,'bb','B'),(3,'ccc','C'),(4,'dddd','D'),(5,'eeeee','E'),(6,'fff','F'),(7,'gg','G');
C1: CREATE INDEX idx_id_length on t1(LENGTH(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LENGTH(col) <= 2 ;
MC: wait until C1 ready;

C2: UPDATE t1 SET col = 'abcd' WHERE col IN ('ccc') or col LIKE '%eeeee%';
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 1,2,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 3,5 are updated */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,2,7 are deleted, id = 3,5 are updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 1,2,7 are deleted, id = 3,5 are updated */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
