/*
Test Case: delete & update 
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray
Notes: this case is just for reference

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC (with pk schema)
C2 updated before C1 deleted since C1 takes a long time

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 completed before C1 executed since C1 takes a long time
C2's updated results affect a portion of the C1's deleting instances
C1,C2 where clauses are on pk column (index scan) 
C2 commit, C1 commit
Metrics: data size = small, where clause = simple, schema = single table with pk

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances should be updated first, C1 instances should be deleted based on the original search condition (i.e. its original snapshot)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id > 6 and 0=(select sleep(5)); 
C2: UPDATE t1 SET id = 8 WHERE id = 5;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 5 is updated */
C2: SELECT * FROM t1 ORDER BY 1,2;
C2: commit;
/* expect: C1 finished execution after C2 commit, 1 row (id=7)deleted message, C1 select - id = 7 is deleted */
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: SELECT * FROM t1 ORDER BY 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 5 is updated, id = 7 is deleted */
C3: select * from t1 ORDER BY 1,2;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;


