/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are not overlapped initially(with filtered index)
but C1's updated results affect the C2's deleting instances, C2 execution takes a long time (finished after C1 commit)  

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped (based on where clause)
C1's updated results affect the C2's deleting instances
C2 execution takes a long time (finished after C1 commit)  
C1 where clause uses one filtered index (index scan - totally), C2 where clause uses another filtered index (index scan - totally)
All of C1, C2 instances are using index scan
C1 commit, C2 commit
Metrics: data size = small, index = multiple filtered indexes (2 simple indexes), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be updated 
   C2 instances should be deleted based on its original snapshot

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: CREATE INDEX idx_id on t1(id) WHERE id BETWEEN 4 AND 6;
C1: CREATE INDEX idx_col on t1(col) WHERE col = 'def';
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'def' WHERE id BETWEEN 5 AND 6 USING INDEX idx_id;
C2: DELETE FROM t1 WHERE col = 'def' and sleep(2) = 0 USING INDEX idx_col;
/* expect: no transactions need to wait */
MC: wait until C1 ready;
/* expect: C1 select - id = 5,6 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: C2 finishes execution after C1 commit, 1 row (id=2) deleted message should be generated, C2 select - id = 2 is deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 5,6 are updated, id = 2 is deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;


