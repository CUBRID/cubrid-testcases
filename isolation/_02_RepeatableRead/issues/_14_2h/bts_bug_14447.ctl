/*
Issue Case: CUBRIDSUS-14447 
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test the scenario that the transaction violates unique key constraint in repeatable read

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C1 C2 where clauses are on composite index (i.e. index scan)
C2 try to update an unique key which C1 try to delete
C1 commit, C2 commit
Metrics: schema = single table, index = composite index, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 and C2 can only see the its own delete/update but not other transactions changes (Visibility Test) 
3) C1 instances should be deleted, C2 instances should be updated

NUM_CLIENTS = 3
C1: delete from table t1;
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'A'),(2,'B');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1;
MC: wait until C1 ready;
C2: UPDATE t1 set id = 1 WHERE id = 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1 is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 0 row updated message should generated once C2 ready, C2 select - id = 2 is not updated, but id = 1 is still visible  */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1 is deleted, id = 2 is not updated */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;