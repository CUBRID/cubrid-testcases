/*
Test Case: select & update 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/counter_function/select_update_incrdecr_04.ctl
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/UPDATE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are overlapped, C1 select does affect C2 updates

Test Scenario:
C1 select, C2 update, the affected rows are overlapped (based on where clause)
C1 uses INCR
C1 select affect C2 updates
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(PK), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be updated(increment) by using INCR function 
   C2 instances will be updated after reevaluation 

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',1);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT title, INCR(read_count) FROM t1 WHERE id IN (7); 
MC: wait until C1 ready;
C2: UPDATE t1 SET read_count = 0 WHERE read_count = 1;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 7 is updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: 1 rows (id=3)updated message should be generated once C2 ready, C2 select - id = 3 is updated after reevaluation*/
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 3,7 are updated */
C3: select * from t1 order by 1,2,3;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
