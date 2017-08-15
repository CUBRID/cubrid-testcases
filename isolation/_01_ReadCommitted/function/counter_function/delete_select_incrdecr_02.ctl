/*
Test Case: delete & select 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/DELETE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are not overlapped, 
C1 try to delete a unique index which is C2 try to updating to

Test Scenario:
C1 delete, C2 select, the affected rows are not overlapped (based on where clause)
C2 uses INCR on unique column
C1 try to delete a unique index which is C2 try to updating to
C1 where clause is not no index (heap scan), C2 where clause is on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed 
2) C1 instances will be deleted first 
   C2 instances will be updated(increment) since the duplicate key has been deleted 

NUM_CLIENTS = 3
C1: deleted from table t1;   
C2: select incr from table t1 order by 1,2;
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
C1: CREATE TABLE t1(id INT Unique, title VARCHAR(10), read_count INT);
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE title = 'book7'; 
MC: wait until C1 ready;

C2: SELECT INCR(id) FROM t1 WHERE id = 6;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;


/* expect: C1 select - id = 7 is deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: 1 row (id=6)updated message should be generated once C2 ready, id = 6 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 6 is updated, id = 7 is deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;


C1: quit;
C2: quit;
C3: quit;
