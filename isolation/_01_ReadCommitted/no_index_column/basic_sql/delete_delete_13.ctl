/*
Test Case: delete & delete
Priority: 1
Reference case:
Isolation Level: Read Committed
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped
C1 deleted instances intersect with the instances deleted by C2 
C1 rollback, C2 commit
Metrics: data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C2 needs to wait for C1 completed (Locking Test)
2) None of the C1 instances will be deleted because of C1 rollback, all the C2 instances will be deleted (Visibility Test)  
   (i.e.the version won't be updated, the C2 search condition is totally satisfied) 

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id <= 5;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id > 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1 ~ 5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
/* expect: 4 rows deleted message should generated once C2 ready, C2 select - id = 3-6 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 3-6 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
