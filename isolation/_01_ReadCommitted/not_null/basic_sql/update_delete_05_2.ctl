/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/not_null/basic_sql/update_delete_05.ctl
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1 update does affect C2 delete
C1 update instances are included in C2 delete instances
C1 where clause is not on index (i.e. heap scan), C2 where clause is on index (index scan)
C1 commit, C2 commit
Metrics: schema = single table, index = single index(PK), data size = small, where clause = simple

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
C1: CREATE TABLE t1(id INT NOT NULL PRIMARY KEY, col VARCHAR(10) NOT NULL, tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def',NULL),(3,'ghi','C'),(4,'jkl',NULL),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abc' WHERE tag IS NULL;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE col IN ('def','mno') or id = 1;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,4 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=1) deleted message should generated once C2 ready, C2 select - id = 1 is deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 2,4 are updated, id = 1 is deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
