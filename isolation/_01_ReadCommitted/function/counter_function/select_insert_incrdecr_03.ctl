/*
Test Case: select & insert 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/INSERT scenarios if using click counter function (INCR/DECR) in select query 
C2 insert does affect C1 select, C1 finishes execution after C2 completes since C1 takes a long time  

Test Scenario:
C1 select, C2 insert,
C2 insert does affect C1 select
C1 finishes execution after C2 completes since C1 takes a long time 
C2 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances will be inserted first
   C1 instances will be updated(increment) based on its original snapshot 

NUM_CLIENTS = 3
C1: select from table t1;   
C2: insert into table t1;  
C3: select on table t1; C3 is used to check the final results
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT DECR(read_count) FROM (select sleep(3)) x, t1 WHERE id > 6;
C2: INSERT INTO t1 VALUES(8,'book8',4);
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 8 is inserted */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finishes the execution after C2 commit, 1 row (id= 7) updated message, C1 select - id = 7 is updated, id = 8 is inserted but not updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 8 is inserted, id = 7 is updated */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

