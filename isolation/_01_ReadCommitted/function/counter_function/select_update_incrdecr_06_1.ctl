/*
Test Case: select & update 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/UPDATE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are not overlapped, C1, C2 try to update an unique index to an identical value 

Test Scenario:
C1 select, C2 update, the affected rows are not overlapped (based on where clause)
C1 uses DECR on unique column
C1,C2 try to update an unique index to a identical value
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan)
C1 rollback, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed 
2) C1 instances won't be updated(decrement) since C1 rollback  
   C2 instances will be updated due to the duplicate key has been removed (after reevaluation) 

NUM_CLIENTS = 3
C1: select decr from table t1;   
C2: update table t1;  
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
C1: SELECT title, DECR(id) FROM t1 WHERE id = 1; 
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 0 WHERE title = 'book2';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 ready;
/* expect: C1 select - id = 1 is updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: rollback;
/* expect: 1 row (id=2)updated should be generated once C2 ready, id = 2 is updated */
MC: wait until C1 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 2 is updated */
C3: select * from t1 order by 1,2,3;
C3: commit;
MC: wait until C3 ready; 

C1: quit;
C2: quit;
C3: quit;
