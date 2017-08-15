/*
Test Case: delete & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/not_null/basic_sql/delete_delete_02.ctl
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1 delete instances intersect with C2 delete instances
C1,C2 where clauses are not on NOT NULL column (i.e. index scan)
C1 rollback, C2 commit
Metrics: index = no index, data size = small, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances shouldn't be deleted since C1 rollback
   C2 instances should be deleted from its original snapshot (Visibility/Reevaluation Test)

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT NOT NULL, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 4 or tag >= 'A' and tag <= 'B';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE col = 'abc';
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,2,4 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
/* expect: 2 rows deleted message, C2 select - id = 1,7(C2) are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 1,7 are deleted */
C3: SELECT * FROM t1 order by 1,2;
MC: wait until C3 ready;

C3: commit;
C1: quit;
C2: quit;
C3: quit;

