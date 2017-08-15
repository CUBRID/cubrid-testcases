/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with function index)

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1's update does not affect the C2's delete
C1,C2 where clause uses function index (i.e. index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function indexes(MONTH + YEAR), where clause = simple, schema = single table

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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag DATE);
C1: INSERT INTO t1 VALUES(1,'abc','2010-03-02'),(2,'def','2012-08-13'),(3,'ghi','2014-01-02'),(4,'jkl','2012-03-28'),(5,'mno','2014-01-02'),(6,'pqr','2010-12-11'),(7,'abc','2012-03-05');
C1: CREATE INDEX idx_tag_month on t1(MONTH(tag));
C1: CREATE INDEX idx_tag_year on t1(YEAR(tag));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET tag = '2010-01-07' WHERE YEAR(tag) = 2014;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE MONTH(tag) = 1;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,6 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 4 rows (id=1,3,5,6)deleted message, C2 select - id = 1,3,5,6 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 1,3,5,6 are updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
