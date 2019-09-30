/*
Test Case: update & update
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent UPDATE/UPDATE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 update, the affected rows are not overlapped (based on where clause)
C2 update does affect C1 update
C2 completed before C1 finished execution since C1 takes a long time
C1, C2 where clause are all on index (i.e. index scan)
C1 commit, C2 commit
Metrics: index = single index, data size = small, where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait (Locking Test)
2) C1 instances should be updated based on its own snapshot
   C2 instances should be updated based on its own snapshot (Visibility Test)

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
C1: CREATE TABLE t1(id INT NOT NULL, col VARCHAR(10) NOT NULL, tag VARCHAR(2));
C1: CREATE INDEX idx_col on t1(col) with online parallel 3;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'xyz','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET id = 0 WHERE col IN ('abc','ghi') and 0 = (select sleep(4));
C2: UPDATE t1 SET col = 'abc' WHERE col = 'jkl';
/* expect: no transactions need to wait, C2 finished before C1 completed */
MC: wait until C2 ready;
/* expect: C2 select - id = 4 is updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: C1 finished execution after C2 commit, 3 rows updated message, C1 select - id = 1,3(C1),4(C2) are updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: the instances of id = 1,3,4 are updated */
C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
