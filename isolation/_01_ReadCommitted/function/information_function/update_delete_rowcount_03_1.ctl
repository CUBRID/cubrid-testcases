/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC UPDATE/DELETE scenarios if using information function ROW_COUNT in the query
and the affected instances are not overlapped, but C1's updated results affect the C2's deleting instances, 
C2 execution takes a long time (finished after C1 commit)  

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped (based on where clause)
C1's updated results affect the C2's deleting instances
C2 execution takes a long time (finished after C1 commit) 
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be updated, the row_count requested by C1 will be returned based on its own snapshot(session)  
   C2 instances should be deleted based on its original snapshot, the row_count requested by C2 will be returned based on its own snapshot(session) 

NUM_CLIENTS = 2
C1: update table t1;  select row_count from table t1;
C2: delete from table t1;  select row_count from table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id ON t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abc' WHERE id >= 5 and id <= 6;
C2: DELETE FROM t1 WHERE col = 'abc' and sleep(2)=0;
/* expect: no transactions need to wait */
MC: wait until C1 ready;
/* expect: C1 select - row_count = 2 (id=5,6) is returned */
C1: SELECT ROW_COUNT();
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: C2 finishes execution after C1 commit, 2 row (id=1,7) deleted message should be generated, C2 select - row_count = 2 is returned */
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
