/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with pk schema)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 try to update the pk column to a duplicate key which is C1 try to deleting 
C1, C2 where clauses are on pk column (index scan) 
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, schema = single table with pk

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances should be deleted, C2 instances should be updated (since the duplicate key has been deleted)

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
C1: DELETE FROM t1 WHERE id >=5 and id <= 6;
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 5 WHERE id = 7;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 5,6 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 rows (id = 7)updated message should generated once C2 ready, C2 select - id = 7 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: id = 5,6 are deleted, id = 7 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;