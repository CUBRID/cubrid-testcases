/*
Test Case: delete & delete
Priority: 1
Reference case:
Isolation Level: Read Committed
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are not overlapped

Test Scenario:
C1 delete, C2 delete, the affected rows are not overlapped
C1 commit, C2 rollback
C2 contains a read query after C1 committed
Metrics: data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C2 can see C1 changes after C1 committed. (Visibility Test)
3) C1 instances are deleted, C2 instances aren't deleted since rollback (Data Consistency) 

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: delete from table t1;  
C3: select on table t1; C3 is used to check the updated result
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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1 or id = 4;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE id = 5 or id = 6;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - id = 1,4 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 5,6 are deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,4-6 are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: rollback;
MC: wait until C2 ready;

/* expect: the instances of id = 1,4 are deleted, whereas id = 5,6 are not deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;


C1: quit;
C2: quit;
C3: quit;

