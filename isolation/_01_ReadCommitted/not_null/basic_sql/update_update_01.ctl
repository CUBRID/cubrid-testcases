/*
Test Case: update & update
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent UPDATE/UPDATE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 update, the affected rows are not overlapped (based on where clause)
C1 update doesn't affect C2 update
C1, C2 where clause are all on NOT NULL column (i.e. index scan)
C1 commit, C2 commit
Metrics: index = single index(unique), data size = small, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 instances should be updated based on its own snapshot
   C2 instances should be updated based on its own snapshot (Visibility Test)

NUM_CLIENTS = 3
C1: update table t1;  
C2: update table t1;  
C3: select on table t1; C3 is used to check for the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT NOT NULL UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd' WHERE id = 5;
MC: wait until C1 ready;

C2: UPDATE t1 SET col = 'abcd' WHERE id = 7;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 5 is updated */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 7 is updated */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 5(C1),7(C2) are updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: id = 5,7 are updated  */
C3: SELECT * FROM t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
