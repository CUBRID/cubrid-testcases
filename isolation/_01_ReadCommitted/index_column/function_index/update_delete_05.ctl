/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with function index)
C1 update affect C2 delete

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1's update affect the C2's delete
C1 where clause uses function index (i.e. index scan), C2 where clause doesn't use function index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = composite function index(ABS + LENGTH), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed  
2) C1 instances should be updated, C2 instances should be deleted after reevaluation

NUM_CLIENTS = 3
C1: update table t1;  
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
C1: INSERT INTO t1 VALUES(1,'abcd','A'),(2,'defg','B'),(3,'ghi','C'),(4,'jkmnl','D'),(5,'mnopq','E'),(6,'pqr','F'),(7,'abcdefg','G');
C1: CREATE INDEX idx_id on t1(ABS(id));
C1: CREATE INDEX idx_col on t1(LENGTH(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET tag = 'B' WHERE ABS(id) = 2 or LENGTH(col) = 3;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE tag = 'B';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows (id=2,3)deleted message, C2 select - id = 2,3 are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 2,3 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

