/*
Test Case: update & delete
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped (based on where clause)
C1 update does affect C2 delete
C1 where clause is on NOT NULL column (i.e. index scan), C2 where clause is not on NOT NULL column (i.e. heap scan)
C1 commit, C2 commit
Metrics: index = single index(PK), data size = small, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 instances should be updated based on its own snapshot
   C2 instances should be deleted based on its original snapshot (Visibility Test)

NUM_CLIENTS = 3
C1: update table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT NOT NULL PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abc' WHERE id = 3;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE col = 'abc';
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 3 is updated */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;
/* expect: C2 select - id = 1,7 are deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expect: C2 select - id = 1,7(C2) are deleted, id = 3(C1) is updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 3 is updated, id = 1,7 are deleted  */
C3: SELECT * FROM t1 order by 1,2;
MC: wait until C3 ready;


C1: quit;
C2: quit;
C3: quit;

