/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with composite index),
C2 updated before C1 deleted since C1 takes a long time

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 completed before C1 executed since C1 takes a long time
C1's updated results affect a portion of the C2's deleting instances
C1,C2 where clauses are on index column (index scan) 
C2 updates index column
C2 commit, C1 commit
Metrics: data size = small, index = composite index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances should be updated first, C1 instances should be deleted based on the original search condition (i.e. its original snapshot)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_id_col on t1(id,col) with online parallel 3;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 1 and id <= 3; 
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 2 WHERE id IN (4,6);
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 4,6 are updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: C1 finished execution after C2 commit, 3 rows (id=1,2,3)deleted message, C1 select - id = 1,2,3 are deleted */
MC: wait until C2 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect: the instances of id = 5,6 are updated, id = 1,2,3 are deleted */
C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;

