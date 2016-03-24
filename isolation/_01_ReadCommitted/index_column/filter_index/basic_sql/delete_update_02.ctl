/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with filtered index)
C1 try to delete a unique index that C2 try to update to

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 try to delete a unique index that C2 try to update to 
C1,C2 where clause uses filtered index (i.e. index scan - totally)
All C1, C2 instances are using index scan
C1 commit, C2 commit
Metrics: data size = small, index = single filtered index(Unique), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances should be deleted, C2 instances should be updated since the duplicate key has been removed

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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'xyz','G');
C1: CREATE INDEX idx_col on t1(col) where col IN ('pqr','xyz');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE col = 'xyz' USING INDEX idx_col;
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 7 WHERE col = 'pqr' USING INDEX idx_col;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 7 is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=6)updated message, C2 select - id = 6 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 7 is deleted, id = 6 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
