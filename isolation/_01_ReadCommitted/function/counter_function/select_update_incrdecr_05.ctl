/*
Test Case: select & update 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/UPDATE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are not overlapped, C2 update does affect C1 select, 
C1 finished execution after C2 completed since C1 takes a long time 

Test Scenario:
C1 select, C2 update, the affected rows are not overlapped (based on where clause)
C1 uses INCR
C2 update does affect C1 select
C1 finished execution after C2 completed since C1 takes a long time 
C2 commit, C1 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances will be updated first 
   C1 instances will be updated(increment) based on its original search condition(snapshot) 

NUM_CLIENTS = 3
C1: select incr from table t1;   
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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',5);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT title, INCR(read_count) FROM (select sleep(4) as x),t1 WHERE read_count = 0 order by 1,2; 
C2: UPDATE t1 SET read_count = 0 WHERE id >= 1 and id <= 3;
/* expect: no transactions need to wait, assume C2 finished before C1 */
MC: wait until C2 ready;
/* expect: C2 select - id = 1,2,3 are updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finish the execution after C2 commit, 1 row (id= 4) updated message, C1 select - id = 4 is updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 1-4 are updated */
C3: select * from t1 order by 1,2,3;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

