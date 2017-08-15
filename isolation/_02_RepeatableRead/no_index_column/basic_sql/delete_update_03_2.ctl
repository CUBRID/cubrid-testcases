/*
Test Case: delete & update
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/no_index_column/basic_sql/delete_update_03.ctl
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with no index schema)

Test Scenario:
C1 delete, C2 update, the affected rows are overlapped (based on where clause)
C1's deleting the instances intersect with the C2's updating instances
C1 commit, C2 commit
Metrics: schema = single table, index = single index, data size = small, where clause = simple

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
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(1,'bcd');INSERT INTO t1 VALUES(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id BETWEEN 3 AND 5;
MC: wait until C1 ready;
C2: UPDATE t1 set col = 'abcd' WHERE id >= 4 AND id <= 6;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 3-5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 0 row updated message should generated once C2 ready, C2 select - id = 6 is not updated, id = 3-5 are still existed */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 3-5 are deleted, id = 6 is not updated */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;