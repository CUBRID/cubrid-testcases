/*
Test Case: select & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/counter_function/select_delete_incrdecr_01.ctl
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/DELETE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are not overlapped

Test Scenario:
C1 select, C2 update, the affected rows are not overlapped (based on where clause)
C1 uses DECR
C1 select doesn't affect C2 deletes
C1 where clause is not on index (heap scan), C2 where clause is on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique + Composite index), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances will be updated(decrement) by using INCR function 
   C2 instances will be deleted 

NUM_CLIENTS = 3
C1: select from table t1;   
C2: delete from table t1;  
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
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: CREATE INDEX idx_id_title on t1(id,title);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',2),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT title, DECR(read_count) FROM t1 WHERE read_count = 3 order by 1,2; 
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE title IN ('book4','book7');
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 1 is updated */
C1: SELECT * FROM t1 order by 1,2,3;
MC: wait until C1 ready;

/* expect: C2 select - id = 4,7 are deleted */
C2: SELECT * FROM t1 order by 1,2,3;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 4,7 are deleted, id = 1 is updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 1,5 are updated, id = 4,7 are deleted */
C3: select * from t1 order by 1,2,3;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
