/*
Test Case: delete & delete
Priority: 1
Reference case: 
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with pk schema)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped
C1 delete instances are included in the instances from C2 delete 
C1, C2 where clauses are on pk (index scan)
C1 commit, C2 commit
Metrics: schema = with pk, data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C2 needs to wait C1 completed 
2) The instances of C1 will be deleted, the overlapped C2 instances won't be deleted but the remained(non-overlapped) instances will 
   (i.e.the version will be updated, the C2 search condition is partially satisfied) 

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id > 4;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id > 3;
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 5,6,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row deleted message should generated once C2 ready, C2 select - id = 4,5,6,7 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 4,5,6,7 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

