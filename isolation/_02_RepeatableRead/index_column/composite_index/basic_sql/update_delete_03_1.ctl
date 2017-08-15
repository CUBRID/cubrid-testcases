/*
Test Case: update & delete
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with composite index schema)

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped (based on where clause)
C1's updates do affect the C2's deletes
C1 C2 where clauses are on composite index column (i.e. index scan)
C1 commit, C2 commit
Metrics: schema = single table, index = composite index, data size = small, where clause = simple

Test Point:
1) C2 doesn't need to wait until C1 completed (Locking Test)
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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_id_col on t1(id,col);
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = 8 WHERE id = 1 AND col = 'abc';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id >= 7 AND col = 'abc';
/* expect: C2 doesn't need to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 1 is updated */
C1: SELECT * FROM t1 ORDER BY 1,2;
C1: commit;
/* expect: 1 rows (id=7)deleted message , C1 select - id = 7 is deleted, id = 1 is unchanged */
C2: SELECT * FROM t1 ORDER BY 1,2;
C2: commit;
/* expect: the instances of id = 7 is deleted, id = 1 is updated */
C3: select * from t1 ORDER BY 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;