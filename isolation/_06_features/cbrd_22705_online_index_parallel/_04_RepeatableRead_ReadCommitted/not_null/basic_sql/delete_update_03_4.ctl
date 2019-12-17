/*
Test Case: delete & update 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/not_null/basic_sql/delete_update_03.ctl
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 completed before C1 finished execution since C1 takes a long time
C2 update does affect C1 delete
C1,C2's where clauses are on index column (index scan)
C2 rollback, C1 commit
Metrics: data size = small, index = multiple index(unique+simple), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C2 instances shouldn't be updated since C2 rollback
   C1 instances should be deleted based on its original snapshot (Visibility Test)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT NOT NULL UNIQUE, col VARCHAR(10) NOT NULL, tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id) with online parallel 7;
C1: CREATE INDEX idx_col on t1(col) with online parallel 3;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE (id IN (5,7) or col = 'def') and 0 = (select sleep(6)); 
C2: UPDATE t1 SET col = 'def' WHERE col IN ('ghi','pqr') ;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 3,6 are updated */
C2: SELECT * FROM t1 order by 1,2;
C2: rollback;
MC: wait until C2 ready;
/* expect: C1 finished execution after C2 commit, 3 rows deleted message, C1 select - id = 2,5,7(C2) are deleted */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect: the instances of id = 2,5,7 are deleted, no instance is updated */
C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
