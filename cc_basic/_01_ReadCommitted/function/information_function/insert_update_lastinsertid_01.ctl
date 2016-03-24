/*
Test Case: insert & update 
Priority: 1
Reference case:
Author: Ray
Function: LAST_INSERT_ID()

Test Plan: 
Test MVCC INSERT/UPDATE scenarios if using information function LAST_INSERT_ID in the query 

Test Scenario:
C1 insert, C2 update
C1 selects LAST_INSERT_ID
C1 insert values on an auto_increment column
C2 updates the auto_increment column to an identical value 
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique,auto_increment), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be inserted, the last_insert_id requested by C1 will be retrieved based on its own snapshot(session) 
   C2 instances won't be updated since duplicate key constraint error (after reevaluation)

NUM_CLIENTS = 2
C1: insert into table t1; select last_insert_id from table t1;
C2: update table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT UNIQUE AUTO_INCREMENT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 (col,tag) VALUES('abc','A'),('def','B'),('ghi','C'),('jkl','D'),('mno','E'),('pqr','F'),('stu','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t1 (col,tag) VALUES('xyz','H');
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 8 WHERE id = 7;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - last insert id = 8 is selected */
C1: SELECT LAST_INSERT_ID();
C1: commit;
/* expect: a duplicate key constraint error should be generated once C2 ready, no instance is updated, last insert id = null */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: SELECT LAST_INSERT_ID();
C2: commit;

C1: quit;
C2: quit;