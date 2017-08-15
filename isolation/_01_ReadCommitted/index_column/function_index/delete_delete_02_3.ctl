/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/function_index/delete_delete_01.ctl/delete_delete_02.ctl
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with function index)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1,C2's where clauses use function index (i.e. index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function index(MONTH+YEAR), where clause = simple, DELETE state = single table deletion

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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag DATE);
C1: INSERT INTO t1 VALUES(1,'abc','2010-03-02'),(2,'def','2012-08-13'),(3,'ghi','2014-01-02'),(4,'jkl','2012-03-28'),(5,'mno','2014-01-02'),(6,'pqr','2010-12-11'),(7,'abc','2012-03-05');
C1: CREATE INDEX idx_tag_month on t1(MONTH(tag));
C1: CREATE INDEX idx_tag_year on t1(YEAR(tag));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE MONTH(tag) = 3;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE YEAR(tag) = 2012;
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,4,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: no instance deleted message should generated once C2 ready, C2 select - no instance deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready; 
/* expect: the instances of id = 1,4,7 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
