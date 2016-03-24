/*
Test Case: select & select 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/counter_function/select_select_incrdecr_09.ctl
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using click counter function (INCR/DECR) in select queries, 
and the affected rows are not overlapped, C2 select does affect C1 select
C1 select takes a long time (finishes the execution after C2 commit)

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses DECR and C2 uses DECR
C2 select does affect C1 select
C1 select takes a long time (finishes the execution after C2 commit)
C1 where clause is on one filtered index (index scan - totally), C2 where clause is on another filtered index (index scan - totally) 
C2 commit, C1 commit
Metrics: data size = small, index = multiple filtered index(2 indexes), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances will be updated(decrement) first
   C1 instances will be updated(decrement) based on its original snapshot 

NUM_CLIENTS = 3
C1: select decr from table t1;   
C2: select decr from table t1;  
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
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',0);
C1: CREATE INDEX idx_id on t1(id) WHERE id IN (1,3,5);
C1: CREATE INDEX idx_title on t1(title) WHERE title IN ('book6');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT title, DECR(read_count) FROM t1 WHERE title = 'book6' and sleep(2)=0 USING INDEX idx_title(+); 
C2: SELECT title, DECR(read_count) FROM t1 WHERE id = 1 USING INDEX idx_id(+);
/* expect: no transactions need to wait, assume C2 finished before C1 */
MC: wait until C2 ready;
/* expect: C2 select - id = 1 is updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finish the execution after C2 commit, 1 rows (id=6)updated message, C1 select - id = 6 is updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 1,6 are updated */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

