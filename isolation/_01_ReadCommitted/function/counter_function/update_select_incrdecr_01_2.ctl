/*
Test Case: update & select 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/counter_function/update_select_incrdecr_01.ctl
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC UPDATE/SELECT scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are not overlapped, C2 select does affect C1 update, 
C1 finished execution after C2 completed since C1 takes a long time 

Test Scenario:
C1 update, C2 select, the affected rows are not overlapped (based on where clause)
C2 uses INCR
C2 select does affect C1 update
C1 finished execution after C2 completed since C1 takes a long time 
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = composite index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances will be updated(increment) fist by using INCR function 
   C1 instances will be updated based on its original search condition(snapshot) 

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
C1: CREATE TABLE t1(id INT UNIQUE, title VARCHAR(10), read_count INT);
C1: CREATE UNIQUE INDEX idx_id_title on t1(id,title);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',4),(6,'book6',2),(7,'book7',7);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET read_count = 0 WHERE (id BETWEEN 3 AND 4 or read_count = 3); 
MC: wait until C1 ready;
C2: SELECT DECR(read_count) FROM t1 WHERE read_count = 4;
MC: wait until C2 ready;
/* expect: C2 select - id = 5 is updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finish the execution after C2 commit, 3 rows (id=1,3,4) updated message, C1 select - id = 1,3,4 are updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: the instances of id = 1,3,4,5 are updated */
C3: select * from t1 order by 1,2,3;

C1: quit;
C2: quit;
C3: quit;

