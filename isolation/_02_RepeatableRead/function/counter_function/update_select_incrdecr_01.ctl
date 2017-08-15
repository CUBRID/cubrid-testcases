/*
Test Case: update & select 
Priority: 1
Reference case:
Isolation Level: Repeatable Read
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC UPDATE/SELECT scenarios if using click counter function (INCR/DECR) in select query, 

Test Scenario:
C1 update, C2 select(decr), the affected rows are not overlapped (based on where clause)
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 C2 can only see their own changes (Visibility Test)
3) C1 instances should be deleted, where as C2 instances should updated


NUM_CLIENTS = 3
C1: deleted from table t1;   
C2: select incr from table t1;
C3: select on table t1; C3 is used to check the final results
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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3);INSERT INTO t1 VALUES(2,'book2',5);INSERT INTO t1 VALUES(3,'book3',1);INSERT INTO t1 VALUES(4,'book4',0);INSERT INTO t1 VALUES(5,'book5',3);INSERT INTO t1 VALUES(6,'book6',1);INSERT INTO t1 VALUES(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET read_count = 0 WHERE id IN (1,6); 
MC: wait until C1 ready;
C2: SELECT id, title, DECR(read_count) FROM t1 WHERE id = 5 order by 1,2;
/* expect: no transactions need to wait*/
MC: wait until C2 ready;
/* expect: C1 select - id = 1,6 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: C2 select - id = 5 is updated, id = 1,6 are still visible and unchanged */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,6 are updated, id = 5 is deleted */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
