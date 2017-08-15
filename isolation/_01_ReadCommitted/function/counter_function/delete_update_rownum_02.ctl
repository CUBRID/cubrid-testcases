/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray
Function: ROWNUM(INST_NUM)

Test Plan: 
Test MVCC DELETE/UPDATE scenarios (locks - X_LOCK on instances) if using ROWNUM function (ROWNUM/INST_NUM) in delete/update queries, 
and the affected rows are overlapped

Test Scenario:
C1 delete, C2 update, the selected rows are overlapped (based on where clause)
C1,C2 only use ROWNUM in their where clauses
C1 commit, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances should be deleted, C2 instances shouldn't be updated in this case 
   since the search condition is no more satisfied (after reevaluation)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;
C3: select on table t1; C3 is used to check the updated result  
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1:  CREATE INDEX idx_id ON t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ROWNUM >= 5; 
MC: wait until C1 ready;
C2: UPDATE t1 SET tag = 'X' WHERE ROWNUM >= 6; 
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 3 rows are deleted */
C1: SELECT count(*) FROM t1;
C1: commit;
/* expect: no instance updated message once C2 ready, C2 select - no instance is deleted */
MC: wait until C2 ready;
C2: SELECT count(*) FROM t1;
C2: commit;
MC: wait until C2 ready;
/* expect: left 4 rows and no tag is updated to 'X' */
C3: select count(*) from t1;
C3: select * from t1 where tag = 'X' ;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

