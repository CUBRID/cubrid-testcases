/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC UPDATE/SELECT scenarios if using click counter function (INCR/DECR) in select query, 

Test Scenario:
C1 update, C2 select, the affected rows are not overlapped (based on where clause)
C2 try to update an unique key that C1 also try to update 
C1,C2 where clauses are not on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = composite index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait C1 completed
2) C1 instances will be updated 
   C1 instances won't be updated after reevaluation

NUM_CLIENTS = 3
C1: select from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check the final results
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
C1: CREATE TABLE t1(id INT UNIQUE, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',4),(6,'book6',2),(7,'book7',4);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = 8 WHERE id = 1;
MC: wait until C1 ready;
C2: SELECT INCR(id) FROM t1 WHERE id = 7;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1 is updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: a key violation error message once C2 ready, C2 select - no data is updated by C2, id = 1 is updated by C1*/
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1 are updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
