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
C2 uses DECR
C2 select does affect C1 update
C1 finished execution after C2 completed since C1 takes a long time 
C1,C2's where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances will be updated(decrement) fist by using DECR function 
   C1 instances will be updated based on its original search condition(snapshot) 

NUM_CLIENTS = 3
C1: select decr from table t1;   
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
C1: CREATE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',4),(6,'book6',2),(7,'book7',4);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET read_count = 4 WHERE id IN (3,5,7) and (select sleep(6))=0;
MC: sleep 2; 
C2: SELECT DECR(id) FROM t1 WHERE id IN (6);
/* expect: no transactions need to wait, assume C2 finished before C1 */
MC: wait until C2 ready;
/* expect: C2 select - id = 6 is updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finish the execution after C2 commit, 3 rows (id=3,5,7) updated message, C1 select - id = 3,5,7 are updated */
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 3,5,6,7 are updated */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

