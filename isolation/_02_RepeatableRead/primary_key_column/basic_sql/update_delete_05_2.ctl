/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/primary_key_column/basic_sql/update_delete_05.ctl
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with pk schema)

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped
C1's updates do not affect the C2's deletes
C1, C2 where clause are all on pk (i.e. index scan), C1 range-type search (i.e. index range scan) - case 3 
C2 commit, C1 commit
Metrics: schema = single table with pk, data size = small, where clause = simple

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd' WHERE id >= 6 AND id <= 7;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id = 3;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 6,7 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect: 1 row (id=3) deleted message should generated once C2 ready, C2 select - id = 3 is deleted, but id = 6,7 are not updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 6,7 is updated & id = 3 is deleted */
C3: select * from t1 order by 1,2;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
