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
C1,C2's where clause are not on index column (heap scan)
C2 commit, C1 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C2 instances should be updated first
   C1 instances should be deleted based on its original snapshot (Visibility Test)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check for the updated result
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
C1: CREATE TABLE t1(id INT NOT NULL, col VARCHAR(10) NOT NULL, tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE (tag >= 'C' and tag <= 'D') and 0 = (select sleep(4)); 
C2: UPDATE t1 SET tag = 'C' WHERE col = 'abc' ;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 1,7 are updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: C1 finished execution after C2 commit, 2 rows deleted message, C1 select - id = 3,4(C2) are deleted, 1,7(C1) are updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect: the instances of id = 1,7 are updated, id = 3,4 are deleted */
C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
