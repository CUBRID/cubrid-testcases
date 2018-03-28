/*
Test Case: delete & select 
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray
Function: ROWNUM(INST_NUM)

Test Plan: 
Test MVCC DELETE/SELECT scenarios (locks - X_LOCK on instance) if using ROWNUM function (ROWNUM/INST_NUM) 

Test Scenario:
C1 delete, C2 select
C1,C2 uses ROWNUM in their where clauses
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test) 
2) C2 can not see C1 changes once C1 completed (Visibility)

NUM_CLIENTS = 2
C1: delete from table t1;   
C2: select from table t1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1,t2;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: RENAME TABLE t1 as t2;
C1: CREATE TABLE t1 as SELECT * FROM t2 ORDER BY id; 
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ROWNUM = 5; 
MC: wait until C1 ready;
C2: SELECT count(*) FROM t1 WHERE ROWNUM = 3; 
/* expect: no transactions need to wait, C2 select - id = 3 is selected */
MC: wait until C2 ready;
/* expect: C1 select - id = 5 is deleted */
C1: SELECT count(*) FROM t1;
C1: commit;
MC: wait until C1 ready;
/* expect: C2 select - all the data is selected, id = 5 is still visible */
C2: SELECT count(*) FROM t1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
