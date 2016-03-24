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
C1 update, C2 select(incr), the affected rows are overlapped (based on where clause)
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test) 
2) C1 C2 can only see their own changes (Visibility Test)
3) C1 instances should be deleted, where as C2 instances shouldn't updated

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
C1: UPDATE t1 SET read_count = 10 WHERE id >= 2 and id <= 3; 
MC: wait until C1 ready;
C2: SELECT id, title, INCR(read_count) FROM t1 WHERE id = 3 order by 1,2,3;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;
/* expect: "Serializable conflict due to concurrent update" message, no data is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 2,3 are updated */
C3: select * from t1 order by 1,2,3;

C3: commit;
MC: wait until C3 ready;
C1: quit;
C2: quit;
C3: quit;
