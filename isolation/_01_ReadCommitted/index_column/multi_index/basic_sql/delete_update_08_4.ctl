/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with multiple indexes)
C2 updated before C1 deleted since C1 takes a long time

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 completed before C1 executed since C1 takes a long time
C1's updated results affect a portion of the C2's deleting instances
C1,C2's where clauses are on index column (index scan)
C2 rollback, C1 commit
Metrics: data size = small, index = multiple indexes(PK + Unique), where clause = simple, schema = single table

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10) UNIQUE, tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_col on t1(col);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'xyz','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE (id = 3 or col = 'mno' or tag = 'G') and 0 = (select sleep(6)); 
C2: UPDATE t1 SET tag = 'G' WHERE id IN (2,6) ;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 2,6 are updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: rollback;
MC: wait until C2 ready;
/* expect: C1 finished execution after C2 commit, 3 rows (id=3,5,7)deleted message, C1 select - id = 3,5,7 are deleted */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;
/* expect: the instances of id = 3,5,7 are deleted, no instance is updated */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
