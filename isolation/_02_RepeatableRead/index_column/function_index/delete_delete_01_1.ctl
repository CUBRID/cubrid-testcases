/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/index_column/function_index/delete_delete_01.ctl
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC (with function index schema)

Test Scenario:
C1 delete, C2 delete, the affected rows are not overlapped (based on where clause)
C1,C2 where clauses are on index (i.e. index scan) 
C1 commit, C2 commit
Metrics: data size = small, index = function index(LENGTH), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 and C2 can only see the its own deletion but not other transactions deletion (Visibility Test)
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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'a','A');INSERT INTO t1 VALUES(2,'bb','B');INSERT INTO t1 VALUES(3,'ccc','C');INSERT INTO t1 VALUES(4,'dddd','D');INSERT INTO t1 VALUES(5,'eeeee','E');INSERT INTO t1 VALUES(6,'f','F');INSERT INTO t1 VALUES(7,'gggg','G');
C1: CREATE INDEX idx_col_length on t1(LENGTH(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LENGTH(col) >= 3 AND LENGTH(col) <= 4;
MC: wait until C1 ready;
/* expect: C2 select - all the data are selected */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;
C2: DELETE FROM t1 WHERE LENGTH(col) = 2;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 3,4,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: C2 select - id = 2 is deleted, but id = 3,4,7 are still visible */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 2-4,7 are deleted */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;