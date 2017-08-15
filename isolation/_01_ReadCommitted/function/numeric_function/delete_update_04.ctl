/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray
Function: POW

Test Plan: 
Test MVCC DELETE/UPDATE scenarios (locks - X_LOCK on instance) if using numeric function POW in queries, 
and the affected rows are overlapped

Test Scenario:
C1 delete, C2 update, the selected rows are overlapped (based on where clause)
C1 uses POW and C2 uses POW
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = function index(POW), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be deleted, C2 instances will be updated after reevaluation 

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
C1: CREATE INDEX id_read_pow on t1(POW(read_count,2)); 
C1: INSERT INTO t1 VALUES(1,'book1',1),(2,'book2',2),(3,'book3',3),(4,'book4',1),(5,'book5',5),(6,'book6',4),(7,'book7',3);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE POW(read_count,2) <= 4; 
MC: wait until C1 ready;
C2: UPDATE t1 SET read_count = 0 WHERE POW(read_count,2) <= 9;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,2,4 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows (id=3,7)deleted message once C2 ready, C2 select - id = 3,7 are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,2,4 are deleted, id = 3,7 are updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;