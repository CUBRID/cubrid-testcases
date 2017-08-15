/*
Test Case: update & delete
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with no index schema)

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1's updates do affect all the C2's deletes
C1's updating the instances intersect with the C2's delete instances (based on where clause)
C2 contains a read query before delete
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own update/delete but not other transactions changes (Visibility Test) 
3) C1 instances should be updated, C2 instances should be deleted

NUM_CLIENTS = 3
C1: update table t1;  
C2: delete from table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = 0 WHERE id >= 2 and id <= 3;
MC: wait until C1 ready;
/* expect: C2 select - all the data are selected */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;
C2: DELETE FROM t1 WHERE id <= 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are updated */
C1: SELECT * FROM t1 ORDER BY 1,2;
C1: commit;
/* expect: 0 rows deleted message should generated once C2 ready,C2 select - id = 1,2,3 are unchanged */
MC: wait until C2 ready;
C2: SELECT * FROM t1 ORDER BY 1,2;
C2: commit;
/* expect: the instances of id = 2-3 are updated */
C3: select * from t1 ORDER BY 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;