/*
Test Case: delete & delete 
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC (with a basic primary key schema environment) 

Test Scenario:
C1 delete, C2 delete, the affected rows are not overlapped (based on where clause)
C1 where clause is only on PK (index scan), C2 where clause is not on PK (sequence scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 doesn't need to wait (Locking Test)
2) C1 and C2 can only see the its own deletion but not other transactions deletion 
3) All the data affected from C1 and C2 should be deleted (Visibility Test)

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT primary key, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE col = 'pqr';
/* expect: C2 doesn't need to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 1 is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=6) deleted message should generated, C2 select - id = 6 is deleted, but id = 1 is still existed */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,6 are deleted */
C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
C3: quit;