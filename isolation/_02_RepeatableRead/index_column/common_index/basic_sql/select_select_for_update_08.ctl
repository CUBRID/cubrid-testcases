/*
Test Case: select for update & select for update
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test MVCC behaviors for 'FOR UPDATE' clause within common index schema 

Test Scenario:
C1 select for update, C2 select, the affected rows are not overlapped
Test for dead lock
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, index = pk, DELETE state = single table

Test Point:
1) C1 C2 will encounter a deadlock (Locking Test)
2) C1 and C2 can only see the its own deletion but not other transactions update  (Visibility Test)

NUM_CLIENTS = 3
C1: select from table t1 for update;  
C2: select from table t1;  
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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 WHERE id = 1 FOR UPDATE;
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE id = 2 FOR UPDATE;
/* expect: no transaction needs to wait */
MC: wait until C2 ready;
C1: SELECT * FROM t1 WHERE id = 2 FOR UPDATE;
MC: wait until C1 blocked;
C2: SELECT * FROM t1 WHERE id = 1 FOR UPDATE;
MC: pause for deadlock resolution;

C1: commit;
C2: commit;

/* expect: the instances of id = 1,3 is updated */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;


C1: quit;
C2: quit;
C3: quit;

