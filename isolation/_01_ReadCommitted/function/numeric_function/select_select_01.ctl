/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray
Function: ABS

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using numeric function ABS in select queries, 
and the affected rows are not overlapped

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses ABS and C2 uses ABS
C1,C2's where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances will be selected, C2 instances will be selected 

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
C1: CREATE TABLE t1(id INT UNIQUE, title VARCHAR(10), read_count INT);
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(-1,'book1',3),(1,'book2',5),(2,'book3',1),(-2,'book4',0),(3,'book5',3),(4,'book6',2),(-4,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE ABS(id) = 2 order by 1 desc; 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE ABS(id) = 4 order by 1 desc; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 2,-2 are selected */
/* expect: C2 select - id = 4,-4 are selected */
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

