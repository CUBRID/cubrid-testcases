/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray
Function: SIGN

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using numeric function SIGN in select queries, 
and the affected rows are overlapped

Test Scenario:
C1 select, C2 select, the selected rows are overlapped (based on where clause)
C1 uses ABS
C1 where clause is on index (index scan), C2 where clause is not on index (heap index)
C1 commit, C2 commit
Metrics: data size = small, index = single function index(ABS), where clause = simple, schema = single table

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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), status INT);
C1: CREATE INDEX idx_status on t1(ABS(status));
C1: INSERT INTO t1 VALUES(1,'book1',-2),(2,'book2',5),(3,'book3',2),(4,'book4',-1),(5,'book5',3),(6,'book6',1),(7,'book7',-3);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE ABS(status) = 1; 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE title IN ('book1','book3','book7'); 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 4,6 are selected */
/* expect: C2 select - id = 1,3,7 are selected */
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
