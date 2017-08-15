/*
Test Case: select & insert 
Priority: 1
Reference case:
Author: Ray
Function: LAST_INSERT_ID()

Test Plan: 
Test MVCC SELECT/INSERT scenarios if using information function LAST_INSERT_ID in select query 
C1 takes a long for execution(finished after C2 completed)

Test Scenario:
C1 select, C2 insert
C1 uses LAST_INSERT_ID 
C1 takes a long for execution(finished after C2 completed)
C2 insert values on an auto_increment column
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique,auto_increment), where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait
2) C2 instances will be inserted first 
   C1 last_insert_id will be selected based its own snapshot(session)

NUM_CLIENTS = 2
C1: select last_insert_id from table t1;   
C2: insert into table t1; 
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
C1: SELECT LAST_INSERT_ID(), sleep(3);  
C2: INSERT INTO t1 (col,tag) VALUES('xyz','H');
/* expect: no transactions need to wait, C2 finishes execution before C1 */
MC: wait until C2 ready;
/* expect: C2 select - last insert id = 8 is selected */
C2: SELECT LAST_INSERT_ID();
C2: commit;  
MC: wait until C2 ready;
MC: wait until C1 ready;

/* expect: C1 finishes execution after C2 commit. C1 select - last insert id = null is selected */
C1: commit;

C1: quit;
C2: quit;
