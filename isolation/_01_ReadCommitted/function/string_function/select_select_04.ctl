/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent SELECT transactions in MVCC if using string function 
String Function(multiple): REVERSE/SUBSTR

Test Scenario:
C1 select, C2 select, the selected rows are overlapped (based on where clause)
C1 uses REVERSE, C2 uses SUBSTR
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 instances will be selected, C2 instances will be selected (Visibility Testing)

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
C1: INSERT INTO t1 VALUES(1,'abcdefg','A'),(2,'decdettt','B'),(3,'ghixyz','C'),(4,'jkcdefg','D'),(5,'mnoxyz','D'),(6,'pqrxnzy','F'),(7,'abccecdfft','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE REVERSE(SUBSTR(col,3,2)) = 'dc' order by 1; 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE SUBSTR(REVERSE(col),4,2) = 'dc' order by 1; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 1,2,4 are selected */
/* expect: C2 select - id = 1,4,7 are selected */
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
