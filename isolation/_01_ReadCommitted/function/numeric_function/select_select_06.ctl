/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR/ABS

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using numeric + information functions in select queries, 
and the affected rows are overlapped

Test Scenario:
C1 select, C2 select, the selected rows are overlapped (based on where clause)
C1 uses DECR/ABS and C2 uses INCR/ABS
C1 DECR affect C2 INCR
C1,C2's where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be updated by using DECR
   C2 instances will be updated after reevaluation 

NUM_CLIENTS = 2
C1: select from table t1;   
C2: select from table t1;  
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: CREATE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(-1,'book1',3),(1,'book2',5),(2,'book3',1),(-2,'book4',0),(0,'book5',1),(3,'book6',2),(-3,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT DECR(id) FROM t1 WHERE ABS(id) = 0;
MC: wait until C1 ready;
C2: SELECT INCR(id) FROM t1 WHERE ABS(id) = 0; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 0 is updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: C2 select - id = -1,1,0 are updated */
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;

C1: quit;
C2: quit;
