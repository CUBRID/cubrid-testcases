/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray
Function: MOD/ABS

Test Plan: 
Test MVCC DELETE/UPDATE scenarios (locks - X_LOCK on instance) if using multiple numeric functions in queries, 
and the affected rows are not overlapped
C2 update does affect C1 delete, and C1 take a long time to execute(after C2 completed)

Test Scenario:
C1 delete, C2 update, the selected rows are not overlapped (based on where clause)
C2 update does affect C1 delete
C1 take a long time to execute(after C2 completed)
C1 uses MOD and C2 uses ABS
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait
2) C2 instances will be updated first 
   C1 instances will be deleted based on its original snapshot 

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1; 
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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE MOD(read_count,2) = 0 and sleep(2)=0; 
C2: UPDATE t1 SET read_count = 2 WHERE ABS(id) IN (1,3);
/* expect: no transactions need to wait, C2 completed before C1*/
MC: wait until C2 ready;
/* expect: C2 select - id = 1,3 are updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finishes execution after C2 commit, 3 rows deleted message, C1 select - id = 4,6,7 are deleted */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 1,3 are updated, id = 4,6,7 are deleted */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
