/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray
Function: MOD/ABS

Test Plan: 
Test MVCC UPDATE/DELETE scenarios (locks - X_LOCK on instance) if using multiple numeric functions in queries, 
and the affected rows are not overlapped, but C1 update does affect C2 delete

Test Scenario:
C1 update, C2 delete, the selected rows are not overlapped (based on where clause)
C1 update does affect C2 delete
C1 uses MOD and C2 uses ABS
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances will be updated, C2 instances will be deleted based on its own snapshot 

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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',4);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = -3 WHERE MOD(read_count,3) = 0; 
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE ABS(id) = 3; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 1,4,5 are updated */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 3 is deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,4,5 are updated, id = 3 is deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 1,4,5 are updated, id = 3 is deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
