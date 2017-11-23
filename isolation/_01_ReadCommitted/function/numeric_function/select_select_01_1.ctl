/*
Test Case: select & select 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/numeric_function/select_select_01.ctl
Author: Ray
Function: CONV

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using numeric function CONV in select queries, 
and the affected rows are not overlapped

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses CONV and C2 uses CONV
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'f','A'),(2,'f','B'),(3,'a','C'),(4,'a','D'),(5,'b','E'),(6,'b','F'),(7,'e','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE CONV(col,16,2) = '1111' order by 1; 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE CONV(col,16,2) = '1010' order by 1; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;

/* expect: C1 select - id = 1,2 are selected */
/* expect: C2 select - id = 5,6 are selected */
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;
C1: quit;
C2: quit;

