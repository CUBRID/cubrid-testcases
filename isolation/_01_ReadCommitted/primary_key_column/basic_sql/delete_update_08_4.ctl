/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with pk schema)
C2 updated before C1 deleted since C1 takes a long time

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 completed before C1 executed since C1 takes a long time
C1's updated results affect a portion of the C2's deleting instances
C1 where clause is on pk column (index scan), C2 where clause is not on pk column (heap scan)
C2 rollback, C1 commit
Metrics: data size = small, where clause = simple, schema = single table with pk

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances shouldn't be updated since C2 rollback, C1 instances should be deleted

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE (id IN (3,5,7) or col = 'abc') and sleep(1)=0; 
C2: UPDATE t1 SET col = 'abc' WHERE tag IN ('B','D');
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 2,4 are updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: rollback;
/* expect: C1 finished execution after C2 commit, 4 rows (id=1,3,5,7)deleted message, C1 select - id = 1,3,5,7 are deleted */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 1,3,5,7 are deleted, id = 2,4 are updated */
C3: select * from t1 order by 1,2,3;

C1: quit;
C2: quit;
C3: quit;
