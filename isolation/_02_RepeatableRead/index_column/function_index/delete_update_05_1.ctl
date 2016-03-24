/*
Test Case: delete & update
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/index_column/function_index/delete_update_05.ctl
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with function index schema)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 C2 where clauses are on index (i.e. index scan)
C2 try to update an unique key which C1 try to delete
C1 rollback, C2 commit
Metrics: schema = single table, index = function index(LENGTH), data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own delete/update but not other transactions changes (Visibility Test) 
3) C1 instances shouldn't be deleted since rollback, C2 instances shouldn't be updated since an unique key violation

NUM_CLIENTS = 3
C1: delete from table t1;
C2: update table t1;  
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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10) UNIQUE, tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'a','A');INSERT INTO t1 VALUES(2,'bb','B');INSERT INTO t1 VALUES(3,'ccc','C');INSERT INTO t1 VALUES(4,'dddd','D');INSERT INTO t1 VALUES(5,'eeeee','E');INSERT INTO t1 VALUES(6,'f','F');INSERT INTO t1 VALUES(7,'gggg','G');
C1: CREATE INDEX idx_col_length on t1(LENGTH(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LENGTH(col) = 4;
MC: wait until C1 ready;
C2: UPDATE t1 set id = 7 WHERE LENGTH(col) = 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 4,7 are deleted */
C1: SELECT * FROM t1 ORDER BY 1,2;
C1: rollback;
/* expect: an unique key violation error message should generated once C2 ready, C2 select - no data is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 ORDER BY 1,2;
C2: commit;
/* expect: no data is updated/deleted*/
C3: select * from t1 ORDER BY 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;