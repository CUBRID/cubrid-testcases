/*
Test Case: update & delete
Priority: 1
Reference case: 
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are not overlapped initially (with composite index),
but C1's updated results affect the C2's deleting instances, C1 completed before C2 executed

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped initially (based on where clause) 
C1's updated results do affect all the C2's deleting instances
C1 completed before C2 executed since C2 takes a long time
C1 where clause is on index (i.e. index scan), C2 where clause is not on index (i.e. heap scan)
C1 commit, C2 commit
Metrics: schema = single table, index = composite index(Unique), data size = small, where clause = simple

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be updated, C2 instances should be deleted based on the original search condition (i.e. its original snapshot)

NUM_CLIENTS = 3
C1: update table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10) UNIQUE, tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id_col on t1(id,col) with online parallel 7;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'stu','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET tag = 'A' WHERE id IN (2,3,5,6) and col != 'pqr' ;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE tag in ('A','D') and 0 = (select sleep(4)); 
/* expect: no transactions need to wait */
/* expect: C1 select - id = 2,3,5 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: C2 finished execution after C1 commit, 2 rows (id=1,4)deleted message, C2 select - id = 1,4 are deleted */
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 2,3,5 are updated, id = 1,4 are deleted */
C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
