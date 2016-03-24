/*
Test Case: select & select 
Priority: 1
Reference case:
Author: Ray
Isolation Level: Repeatable Read
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using click counter function (INCR/DECR) in select queries

Test Scenario:
C1 select, C2 select, the selected rows are not overlapped (based on where clause)
C1 uses INCR and C2 uses INCR
C1,C2's where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 C2 can only see the their own changes (Visibility Test)
2) C1 instances will be updated(increment) by using INCR function 
   C2 instances will be updated(increment) by using INCR function 

NUM_CLIENTS = 3
C1: select from table t1;   
C2: select from table t1;  
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
C1: CREATE TABLE t1(id INT UNIQUE, title VARCHAR(10), read_count INT);
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'book1',1);INSERT INTO t1 VALUES(2,'book2',2);INSERT INTO t1 VALUES(3,'book3',3);INSERT INTO t1 VALUES(4,'book4',4);INSERT INTO t1 VALUES(5,'book5',5);INSERT INTO t1 VALUES(6,'book6',6);INSERT INTO t1 VALUES(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT title, INCR(read_count) FROM t1 WHERE id = 1 order by 1,2; 
MC: wait until C1 ready;
C2: SELECT title, INCR(read_count) FROM t1 WHERE id = 5 order by 1,2;  
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;
/* expect: C1 select - id = 1 is updated, id = 5 is unchanged */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;
/* expect: C2 select - id = 5 is updated, id = 1 is changed */
C2: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: C2 select - id = 5 is updated, id = 1 is changed */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,5 are updated */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;

