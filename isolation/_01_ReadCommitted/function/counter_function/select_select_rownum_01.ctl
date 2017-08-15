/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray
Function: ROWNUM(INST_NUM)

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using ROWNUM function (ROWNUM/INST_NUM) in select queries, 
and the affected rows are not overlapped

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 select ROWNUM and C2 select ROWNUM
C1,C2 do not use ROWNUM in their where clauses
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1, C2 will see the data including ROWNUM 

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
C1: CREATE TABLE t1(id INT Unique, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT ROWNUM, id, col FROM t1 WHERE id >= 1 and id <= 4; 
MC: wait until C1 ready;

C2: SELECT ROWNUM, id, col FROM t1 WHERE id BETWEEN 5 AND 7; 
/* expect: no transactions need to wait */
/* expect: C1 select - id = 1-4 are selected */
/* expect: C1 select - id = 5-7 are selected */
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
