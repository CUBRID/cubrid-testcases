/*
Test Case: delete & delete 
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC (with multiple indexes schema)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1,C2 where clauses are on different index (i.e. index scan) 
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes(2 simple indexes), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own deletion but not other transactions deletion  (Visibility Test)
3) All the data affected from C1 and C2 should be deleted (Visibility Test)

NUM_CLIENTS = 3
C1: delete from table t1;  
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
C1: CREATE INDEX idx_id on t1(id);
C1: CREATE INDEX idx_col on t1(col);
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 2 AND id <= 3;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE col = 'def';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 0 row deleted message should generated once C2 ready, C2 select - no data is deleted, but id = 2,3 are still visible (mysql behavior with select) */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 2,3 are deleted */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;