/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent SELECT transactions in MVCC if using string function 
String Function(multiple): UPPER/RIGHT

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses UPPER and C2 uses RIGHT(UPPER)
C1,C2 where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function indexes(UPPER + RIGHT), where clause = simple, schema = single table

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
C1: CREATE INDEX idx_col_upper on t1(UPPER(col));
C1: CREATE INDEX idx_col_right on t1(RIGHT(col,3));
C1: INSERT INTO t1 VALUES(1,'abcdefg','A'),(2,'ABCDEFG','B'),(3,'abcdxyz','C'),(4,'axbyczd','D'),(5,'ABCEWRXYZ','D'),(6,'cdefihj','F'),(7,'CDEFxyz','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE UPPER(col) LIKE '%ABCDE%' order by 1,2; 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE RIGHT(UPPER(col),3) = 'XYZ' order by 1,2; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 1,2 are selected */
/* expect: C2 select - id = 3,5,7 are selected */
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
