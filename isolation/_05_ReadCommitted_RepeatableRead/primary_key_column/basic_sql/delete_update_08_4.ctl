/*
Test Case: delete & update
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/primary_key_column/basic_sql/delete_update_08.ctl
Isolation Level: Repeatable Read
Related issue: CUBRIDSUS-14442
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with pk schema)

Test Scenario:
C1 delete, C2 update, the affected rows are overlapped (based on where clause)
C1 C2 where clause are not on pk (i.e. sequence scan) 
C1's deleting the instances intersect with the C2's updating instances
C1 commit, C2 commit
Metrics: schema = single table with pk, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own deletion/update but not other transactions changes (Visibility Test)
   C2 update is executed based on the real time back-end data  
3) All the C1 instances will be deleted, a portion of C2 instances will be updated 
   (i.e.the version will be updated, the C2 search condition is satisfied partially) 

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE col IN ('abc', 'def');
MC: wait until C1 ready;
C2: UPDATE t1 SET col = 'abcd' WHERE col = 'abc' or col = 'jkl';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,2,7 are deleted */
C1: SELECT * FROM t1 ORDER BY 1,2;
C1: commit;
/* expect: 0 row updated message should generated once C2 ready, C2 select - id = 4 is not updated, id = 1,2,7 are still existed and unchanged  */
MC: wait until C2 ready;
C2: SELECT * FROM t1 ORDER BY 1,2;
C2: commit;
/* expect: id = 1,2,7 are deleted, id = 4 is not updated */
C3: select * from t1 ORDER BY 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;

