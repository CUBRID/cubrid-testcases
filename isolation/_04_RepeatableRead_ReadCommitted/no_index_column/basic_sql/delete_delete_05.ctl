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
C2 rollback, C1 rollback
Metrics: data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) transactions cannot see changes with each other since transaction are rollback. (Visibility Test)
3) no instances will be deleted 

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id > 3 and id < 6;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE id >= 1 and id <= 3;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 4,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,2,3 are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: rollback;
MC: wait until C2 ready;

/* expect: C1 select - id = 4,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
MC: wait until C1 ready;

/* expect: no instances are deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;


C3: commit;
C1: quit;
C2: quit;
C3: quit;

