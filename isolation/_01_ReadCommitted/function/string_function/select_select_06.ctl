/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent SELECT transactions in MVCC if using string function and incr/decr 
String Function(single): RTRIM
Information Function: INCR/DECR

Test Scenario:
C1 select, C2 select, the selected rows are overlapped (based on where clause)
C1 uses DECR and C2 uses INCR/RTRIM
C1 DECR affect C2 INCR
C1 where clause is not on index (heap scan), C2 where clause is on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances will be updated by using DECR
   C2 instances will be updated after reevaluation (Visibility/Reevaluation Testing)

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
C1: CREATE UNIQUE INDEX idx_read on t1(read_count);
C1: INSERT INTO t1 VALUES(1,' abc',3),(2,'a b c',4),(3,'ab c ',6),(4,'a bc ',7),(5,'abc ',2),(6,'cde ',0),(7,' cde',5);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT DECR(read_count) FROM t1 WHERE RTRIM(col) = 'abc';
MC: wait until C1 ready;
C2: SELECT INCR(read_count) FROM t1 WHERE read_count <= 2; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 5 is updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: 0 rows updated message once C2 ready, C2 select - no instances are updated */
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;

C1: quit;
C2: quit;
