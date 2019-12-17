/*
Test Case: update & update
Priority: 1
Reference case:
Related issue: CUBRIDSUS-14336
Author: Ray

Test Plan: 
Test concurrent UPDATE/UPDATE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 update, the affected rows are overlapped (based on where clause), the updated columns are overlapped (based on set clause)
C1 update instances intersect with C2 update instances
C1 update does affect C2 update 
C1,C2 where clauses are all on index (i.e. index scan)
C1 commit, C2 commit
Metrics: index = single index, data size = small, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances should be updated
   C2 instances should be updated after reevaluation (Visibility/Reevaluation Test)

NUM_CLIENTS = 3
C1: update table t1;  
C2: update table t1;  
C3: select on table t1; C3 is used to check for the updated result
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
C1: CREATE TABLE t1(id INT NOT NULL, col VARCHAR(10) NOT NULL, tag VARCHAR(2));
C1: CREATE INDEX idx_id on t1(id) with online parallel 3;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = 0, col = 'abc' WHERE id >= 2 and id <= 3;
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 3, col = 'abcd' WHERE id IN (0,1,3);
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: 3 rows updated message should generated once C2 ready, C2 select - id = 1,2,3(C2) are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: id = 1,2,3 are updated */
C3: select * from t1 order by 1,2,3;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
