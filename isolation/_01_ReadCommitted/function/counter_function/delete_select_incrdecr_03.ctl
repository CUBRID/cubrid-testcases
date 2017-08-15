/*
Test Case: delete & select 
Priority: 1
Reference case:
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT/DELETE scenarios if using click counter function (INCR/DECR) in select query, 
and the affected rows are overlapped

Test Scenario:
C1 delete, C2 select, the affected rows are overlapped (based on where clause)
C2 uses INCR
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C2 should update the data based on C1 committed data

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
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',5),(3,'book3',1),(4,'book4',0),(5,'book5',4),(6,'book6',1),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 1; 
MC: wait until C1 ready;
C2: SELECT DECR(read_count) FROM t1 WHERE read_count = 3 order by 1;
/* expect: C2 needs to wait for C1 */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1 is deleted */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;
/* expect: no data updated message, C2 select - id = 1 is deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 1 is deleted */
C3: select * from t1 order by 1,2,3;
C3: commit;
MC: wait until C3 ready;
C1: quit;
C2: quit;
C3: quit;
