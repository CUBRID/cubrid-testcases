/*
Test Case: select & select 
Priority: 2
Reference case:
Author: Ray
Function: ABS/TRUNC

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using mixed numeric function in select queries, 
and the affected rows are not overlapped

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses ABS and C2 uses TRUNC
C1 commit, C2 commit
Metrics: data size = small, index = multiple function indexes, where clause = simple, schema = single table

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), price DECIMAL);
C1: CREATE INDEX idx_id on t1(ABS(id));
C1: CREATE INDEX idx_price on t1(TRUNC(price,2));
C1: INSERT INTO t1 VALUES(-1,'book1',34.599),(1,'book2',34.60),(2,'book3',35.88),(-2,'book4',34.593),(3,'book5',37.10),(4,'book6',38.12),(-4,'book7',34.99);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE ABS(id) = 4; 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE TRUNC(price,2) = 35; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 4,-4, are selected */
/* expect: C2 select - id = 1,-1,-2,-4 are selected */
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
