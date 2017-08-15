/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC DELETE/DELETE scenarios if using information function ROW_COUNT in the query
and the affected rows are not overlapped
C1 try to delete a unique index that C2 try to update to

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 try to delete a unique index that C2 try to update to 
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1,C2 where clause uses filtered index (i.e. index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C2 will be waiting for C1 completed
2) C1 instances should be deleted, the row_count will be returned based on its own snapshot 
   C2 instances should be updated since the duplicate key has been removed, the row_count will be returned after reevaluation 

NUM_CLIENTS = 2
C1: delete from table t1;  select row_count from table t1; 
C2: update table t1;  select row_count from table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id <= 2;
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 2 WHERE id = 3;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 2 (id=1,2) is returned */
C1: SELECT ROW_COUNT();
C1: commit;
/* expect: 1 row (id=3)updated message, C2 select - row_count = 1 is returned */
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: SELECT * FROM t1 order by 1,2;
C2: commit;

C1: quit;
C2: quit;