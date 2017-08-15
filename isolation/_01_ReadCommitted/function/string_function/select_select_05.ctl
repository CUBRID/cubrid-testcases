/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent SELECT transactions in MVCC if using string function and incr/decr 
String Function(single): TRIM
Information Function: INCR/DECR

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses INCR/TRIM and C2 uses DECR
C1 INCR affect C2 DECR
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes(Unique + function), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 instances will be updated by using INCR, C2 instances will be updated by using DECR (Visibility Testing)

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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), read_count INT);
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: CREATE INDEX idx_col_trim on t1(TRIM(col));
C1: INSERT INTO t1 VALUES(1,'abcf',3),(2,'a b c',3),(3,' abc ',1),(4,'a bc ',4),(5,'abc f',2),(6,'cde ',0),(7,' cde',1);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT INCR(read_count) FROM t1 WHERE TRIM(col) = 'abc'; 
MC: wait until C1 ready;

C2: SELECT DECR(read_count) FROM t1 WHERE read_count >= 4; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;

/* expect: C1 select - id = 3 is updated */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 4 is updated */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 3 is updated(C1-incr), id = 4 is updated(C2-decr) */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
