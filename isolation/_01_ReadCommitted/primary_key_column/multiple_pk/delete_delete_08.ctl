/*
Test Case: delete & delete
Priority: 1
Reference case: 
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with multiple pk schema)

Test Scenario:
The primary key is created on all(in this case: 2) the columns of the table
C1 delete, C2 delete, the affected rows are overlapped
C1 delete instances include(this case - contain) all the instances from C2 delete 
C1,C2 where clauses are on multiple pks 
C1 commit, C2 commit
Metrics: schema = multi-pk, data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C2 needs to wait C1 completed
2) The instances of C1 will be deleted, whereas C2 instances will not
   (i.e. the version will be updated, the C2 search condition is not satisfied anymore)

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), PRIMARY KEY(id, col));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id > 4 or col = 'ghi';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id > 5 or col = 'mno';
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 3,5,6,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 0 row deleted message should generated once C2 ready, C2 select - id = 3,5,6,7 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: all the instances except id = 3,5,6,7 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;