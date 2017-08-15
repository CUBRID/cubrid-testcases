/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray
Function: SIGN/ABS

Test Plan: 
Test MVCC UPDATE/DELETE scenarios (locks - X_LOCK on instance) if using multiple numeric functions in queries, 
and the affected rows are not overlapped 
C1 update does affect C2 delete, C2 takes a long time (finished after C1 completed)

Test Scenario:
C1 update, C2 delete, the selected rows are not overlapped (based on where clause)
C1 update does affect C2 delete
C2 takes a long time (finished after C1 completed)
C1 uses SIGN and C2 uses ABS
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances will be updated first, C2 instances will be deleted based on its own snapshot 

NUM_CLIENTS = 3
C1: update table t1;   
C2: delete from table t1; 
C3: select on table t1; C3 is used to check the updated results 
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
C1: CREATE TABLE t1(id INT UNIQUE, title VARCHAR(10), status INT);
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: CREATE INDEX idx_status_abs on t1(ABS(status));
C1: INSERT INTO t1 VALUES(1,'book1',-3),(2,'book2',5),(3,'book3',-1),(4,'book4',1),(5,'book5',-3),(6,'book6',1),(7,'book7',-1);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET status = -3 WHERE SIGN(status) = 1; 
C2: DELETE FROM t1 WHERE ABS(status) = 3 and sleep(2)=0; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C1 ready;
/* expect: C1 select - id = 2,4,6 are updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: C2 finishes execution after C1 completed, 2 rows deleted message, C2 select - id = 1,5 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 1,4,5 are updated, id = 1,5 are deleted */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
