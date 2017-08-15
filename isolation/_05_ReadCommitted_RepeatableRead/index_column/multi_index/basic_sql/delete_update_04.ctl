/*
Test Case: delete & update
Priority: 1
Reference case: 
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with multiple indexes schema)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1, C2 where clauses are on indexes (i.e. index scan)
C2 try to update an unique index column to a duplicate key which is C1 try to deleting 
C1 commit, C2 commit
Metrics: schema = single table, index = multiple indexes(Unique + simple), data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own delete/update but not other transactions changes (Visibility Test) 
3) C1 instances should be deleted, C2 instances should be updated

NUM_CLIENTS = 3
C1: delete from table t1;
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: CREATE INDEX idx_col on t1(col);
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1; 
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 1 WHERE col = 'def';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1 is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=2) updated message should generated once C2 ready, C2 select - id = 2 is updated, but id = 1 is deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 2 is updated, id = 1 is deleted */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
