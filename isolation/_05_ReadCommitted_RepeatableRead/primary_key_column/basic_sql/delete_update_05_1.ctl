/*
Test Case: delete & update
Priority: 2
Reference case: cc_basic/_02_RepeatableRead/primary_key_column/basic_sql/delete_update_05.ctl
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with pk schema)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 where clause is on pk (i.e. index scan), C2 where clause is not on pk (sequence scan)
C2 update affect C1 delete
C2 updates a pk column
C1 commit, C2 commit
C2 contains a read query before  
C1 commit before C2's read query
Metrics: schema = single table with pk, data size = small, where clause = simple

Test Point:
1) C2 doesn't need to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own deletion/update but not other transactions changes (Visibility Test) 
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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id BETWEEN 0 AND 2; 
MC: wait until C1 ready;
/* expect: C2 select - all the data are selected */
C2: SELECT * FROM t1 ORDER BY 1,2;
MC: wait until C2 ready;
C2: UPDATE t1 SET id = 0 WHERE col = 'mno';
/* expect: C2 doesn't need to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 1,2 are deleted */
C1: SELECT * FROM t1 ORDER BY 1,2;
C1: commit;
/* expect: 1 row (id=5) updated message, C2 select - id = 5 is updated, but id = 1,2 are still existed */
C2: SELECT * FROM t1 ORDER BY 1,2;
C2: commit;
/* expect: the instances of id = 5 is updated, whereas id = 1,2 are deleted */
C3: select * from t1 ORDER BY 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;

