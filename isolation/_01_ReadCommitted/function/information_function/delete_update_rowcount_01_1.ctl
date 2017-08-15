/*
Test Case: delete & update 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/information_function/delete_update_rowcount_01.ctl
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC DELETE/DELETE scenarios if using information function ROW_COUNT in the query
and the affected rows are not overlapped

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1 rollback, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances shouldn't be deleted since C1 rollback, the row_count will be returned based on its own snapshot  
   C2 instances should be updated, the row_count will be returned based on its own snapshot 

NUM_CLIENTS = 2
C1: delete from table t1;  select row_count from table t1;
C2: update table t1;   select row_count from table t1;
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE tag BETWEEN 'B' AND 'C';
MC: wait until C1 ready;

C2: UPDATE t1 SET tag = 'X' WHERE col IN ('pqr','mno');
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - row_count = 2(id=2,3) is returned */
C1: SELECT ROW_COUNT();
MC: wait until C1 ready;
/* expect: C2 select - row_count = 2(id=5,6) is returned */
C2: SELECT ROW_COUNT();
MC: wait until C2 ready;

C1: rollback;
MC: wait until C1 ready;

/* expect: C2 select - row_count = 2 is returned */
C2: SELECT ROW_COUNT();
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
C3: quit;
