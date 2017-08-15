/*
Test Case: insert & select 
Priority: 2
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC INSERT/SELECT scenarios if using click counter function (INCR/DECR) in select query 

Test Scenario:
C1 insert, C2 select
C2 uses INCR 
C1 insert values on an unique index
C1 insert does affect C2 select with duplicate key constraint 
C1 rollback, C2 commit
Metrics: data size = small, index = single index(PK), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances won't be inserted because of C1 rollback 
   C2 instances will be updated(increment) after reevaluation

NUM_CLIENTS = 3
C1: insert into table t1;
C2: select from table t1;  
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
C1: CREATE TABLE t1(id INT UNIQUE, title VARCHAR(10), read_count INT);
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t1 VALUES(8,'book8',4);
MC: wait until C1 ready;
C2: SELECT INCR(id) FROM t1 WHERE id = 7;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 8 is inserted */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
/* expect: 1 row (id=7)updated message should be generated once C2 ready, id = 7 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 7 is updated, no instance is inserted */
C3: select * from t1 order by 1,2;
C3: commit;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
