/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are not overlapped initially(with function index)
but C1's updated results affect the C2's deleting instances, C2 execution takes a long time (finished after C1 commit)  

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped (based on where clause)
C1's updated results affect the C2's deleting instances
C2 execution takes a long time (finished after C1 commit)  
C1 where clause uses one function index (index scan), C2 where clause uses another function index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function indexes (YEAR + MONTH), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be updated 
   C2 instances should be deleted based on its original snapshot

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
C1: UPDATE t1 SET tag = '2014-01-02' WHERE MONTH(tag) = 3;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE YEAR(tag) = 2014;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 1,4,7 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: C2 finishes execution after C1 commit, 2 rows (id=3,5) deleted message should be generated, C2 select - id = 3,5 are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 1,4,7 are updated, id = 3,5 are deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;


