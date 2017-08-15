/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/index_column/function_index/delete_delete_02.ctl
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC (with function index schema)

Test Scenario:
C1 delete, C2 delete, the affected rows are not overlapped (based on where clause)
C1 where clause doesn't uses index (i.e. sequence scan), C2 where clause uses index (index index) 
C1 commit, C2 commit
Metrics: data size = small, index = function index(MONTH+YEAR), where clause = simple, schema = single table

Test Point:
1) C2 doesn't need to wait until C1 completed (Locking Test)
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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag DATE);
C1: INSERT INTO t1 VALUES(1,'abc','2010-03-02');INSERT INTO t1 VALUES(2,'def','2012-08-13');INSERT INTO t1 VALUES(3,'ghi','2014-01-02');INSERT INTO t1 VALUES(4,'jkl','2012-03-28');INSERT INTO t1 VALUES(5,'mno','2014-01-02');INSERT INTO t1 VALUES(6,'pqr','2010-12-11');INSERT INTO t1 VALUES(7,'abc','2012-03-05');
C1: CREATE INDEX idx_tag_month on t1(MONTH(tag));
C1: CREATE INDEX idx_tag_year on t1(YEAR(tag));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE DAY(tag) = 2;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE MONTH(tag) = 8;
/* expect: C2 doesn't need to wait until C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 1,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=2)deleted message, C2 select - id = 2 is deleted, but id = 1,5 are still visible */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,2,5 are deleted */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;