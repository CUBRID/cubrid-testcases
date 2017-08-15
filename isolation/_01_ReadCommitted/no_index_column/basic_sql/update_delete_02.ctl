/*
Test Case: update & delete
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped

Test Scenario:
C1 update, C2 delete, the affected rows are totally overlapped(without where clause)
C1 update all the instances of the table, C2 delete all the instances of the table
C1 commit, C2 commit
Metrics: data size = small, where clause = no, schema = single table

Test Point:
1) C2 needs to wait C1 completed
2) All the C1 instances will updated, all the C2 instances will be deleted 
   (i.e.the version will be updated for both C1 and C2) 

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'test_col';
MC: wait until C1 ready;
C2: DELETE FROM t1;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - all instances are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 7 rows deleted message should generated once C2 ready, C2 select - all instances are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: all the instances of t1 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
