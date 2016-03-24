/*
Test Case: update & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/not_null/basic_sql/update_delete_04.ctl
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1 update doesn't affect C2 delete
C1 update instances contain C2 delete instances
C1 where clause is on index (i.e. index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(PK), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances will be updated
   C2 instances will be deleted after reevaluation (Visibility/Reevaluation Test)

NUM_CLIENTS = 3
C1: update table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT NOT NULL PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = NULL WHERE id >= 4 and id <= 7 and col NOT IN ('def','pqr');
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE tag IN ('B','G');
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 4,5,7 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows deleted message should generated once C2 ready, C2 select - id = 2,7(C2) are deleted, id = 4,5(C1) are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 4,5 are updated, id = 2,7 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
