/*
Test Case: delete & select 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/DELETE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are not overlapped, C2 select does affect C1 delete
C1 finished execution after C2 completed since C1 takes a long time 

Test Scenario:
C1 delete, C2 select, the affected rows are not overlapped (based on where clause)
C2 uses DECR
C2 select affect C1 delete
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances will be updated(increment) first 
   C1 instances will be deleted based on its original search condition(snapshot) 

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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',1),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE read_count = 0; 
MC: wait until C1 ready;
C2: SELECT DECR(read_count) FROM t1 WHERE id = 3;
/* expect: no transactions need to wait, assume C2 finished before C1 */
MC: wait until C2 ready;
/* expect: C2 select - id = 3 is updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;
/* expect: C1 finish the execution after C2 commit, 2 rows (id= 4,7) deleted message, C1 select - id = 4,7 are deleted */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 3 is updated, id = 4,7 are deleted */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
