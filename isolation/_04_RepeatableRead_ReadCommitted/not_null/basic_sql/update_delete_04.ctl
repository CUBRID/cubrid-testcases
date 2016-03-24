/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1 update doesn't affect C2 delete
C1 update instances equal to C2 delete instances
C1,C2 where clauses are all on index (i.e. index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

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
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT NOT NULL UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd' WHERE id >= 1 and id <= 3;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id IN (2,3,6) and tag != 'B';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,2,3 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows deleted message should generated once C2 ready, C2 select - id = 3,6(C2) are deleted, id = 1,2(C1) are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 3,6 are deleted, id = 1,2 are updated */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
