/*
Test Case: update & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/not_null/basic_sql
Author: Ray

Test Plan: 
Test concurrent UPDATE/UPDATE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 update, the affected rows are not overlapped (based on where clause)
C2 try to update an unique index to which C1 is trying to update 
C1 where clause is on index (i.e. index scan), C2 where clause is not on index (heap scan)
C1 commit, C2 commit
Metrics: index = single index(PK), data size = small, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances shouldn't be updated since C1 rollback
   C2 instances should be updated (Visibility/Reevaluation Test)

NUM_CLIENTS = 3
C1: update table t1;  
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
C1: CREATE TABLE t1(id INT NOT NULL PRIMARY KEY, col VARCHAR(10) NOT NULL, tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id) with online parallel 7;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = 8 WHERE id = 2;
MC: wait until C1 ready;

C2: UPDATE t1 SET id = 8 WHERE col = 'jkl';
/* expect: no transactions need to wait */
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2 is updated */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
MC: wait until C1 ready;

/* expect: 1 row updated message, C2 select - id = 4(C2) is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: id = 4 is updated  */
C3: SELECT * FROM t1 order by 1,2;
MC: wait until C3 ready;


C3: commit;
C1: quit;
C2: quit;
C3: quit;
