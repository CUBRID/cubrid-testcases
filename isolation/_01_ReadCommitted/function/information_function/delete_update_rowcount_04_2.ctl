/*
Test Case: delete & update 
Priority: 2
Reference case: 
Author: Ray
Function: ROW_COUNT()

Test Plan: 
Test MVCC DELETE/DELETE scenarios if using information function ROW_COUNT in the query
and the affected rows are overlapped

Test Scenario:
C1 delete, C2 update, the affected rows are overlapped (based on where clause)
C1 selects ROW_COUNT, C2 selects ROW_COUNT
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C2 rollback, C1 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances shouldn't be deleted since C1 rollback, the row_count will be returned based on its own snapshot
   C2 instances should be be updated, the row_count will be returned based on its own snapshot

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 3 and id <= 5; 
MC: wait until C1 ready;
C2: UPDATE t1 SET tag = 'X' WHERE tag IN ('A','C') or col = 'mno';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - row_count = 3 (id=3,4,5) is returned */
C1: SELECT ROW_COUNT();
C1: rollback;
/* expect: 3 rows (id=1,3,5)updated message, C2 select - row_count = 3 is returned */
MC: wait until C2 ready;
C2: SELECT ROW_COUNT();
C2: commit;

C1: quit;
C2: quit;

