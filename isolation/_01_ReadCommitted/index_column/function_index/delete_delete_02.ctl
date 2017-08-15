/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with function index)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1,C2 where clauses use function index (i.e. index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single function index(LTRIM), where clause = simple, DELETE state = single table deletion

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'a','A'),(2,'a ','B'),(3,' a','C'),(4,'b b','D'),(5,' bb','E'),(6,'bb ','F'),(7,' bb ','G');
C1: CREATE INDEX idx_col_ltrim on t1(LTRIM(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LTRIM(col) = 'a';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE LTRIM(col) IN ('a','bb','bb ');
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,3 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 3 rows (id=5,6,7)deleted message should generated once C2 ready, C2 select - id = 5,6,7 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 1,3,5,6,7 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
