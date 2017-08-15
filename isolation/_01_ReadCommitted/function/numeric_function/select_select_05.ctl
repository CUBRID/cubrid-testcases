/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR/POWER

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using numeric + information functions in select queries, 
and the affected rows are not overlapped

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses INCR/POWER and C2 uses DECR/POWER
C1 INCR affect C2 DECR
C1,C2's where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes(Unique + simple), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances will be updated by using INCR, C2 instances will be updated by using DECR 

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
C1: CREATE INDEX idx_read on t1(read_count);
C1: INSERT INTO t1 VALUES(1,'book1',1),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',1),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT INCR(read_count) FROM t1 WHERE POWER(read_count,2) = 4; 
MC: wait until C1 ready;

C2: SELECT DECR(read_count) FROM t1 WHERE POWER(read_count,2) = 9; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;

/* expect: C1 select - id = 6 is updated */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 1 is updated */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 6 is updated(incr), id = 1 is updated(decr) */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
