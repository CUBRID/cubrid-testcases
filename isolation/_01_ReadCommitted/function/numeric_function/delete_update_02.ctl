/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray
Function: LOG10

Test Plan: 
Test MVCC DELETE/UPDATE scenarios (locks - X_LOCK on instance) if using numeric function LOG10 in queries, 
and the affected rows are not overlapped
C2 try to update an unique index to which C1 is trying to delete 

Test Scenario:
C1 delete, C2 update, the selected rows are not overlapped (based on where clause)
C2 try to update an unique index to which C1 is trying to delete 
C1 uses LOG10 and C2 uses LOG10
C1 commit, C2 commit
Metrics: data size = small, index = single index(PK), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be deleted, C2 instances will be updated since the duplicate key has been removed 

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',1),(2,'book2',10),(3,'book3',100),(4,'book4',10),(5,'book5',1000),(6,'book6',100),(7,'book7',1000);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LOG10(read_count) >= 3; 
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 5 WHERE LOG10(read_count) = 0;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 5,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=1)deleted message once C2 ready, C2 select - id = 1 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 5,7 are deleted, id = 1 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;