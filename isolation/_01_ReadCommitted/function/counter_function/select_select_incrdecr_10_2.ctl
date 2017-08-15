/*
Test Case: select & select 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/function/counter_function/select_select_incrdecr_10.ctl
Author: Ray
Function: INCR/DECR

Test Plan: 
Test MVCC SELECT scenarios (locks - IX_LOCK) if using click counter function (INCR/DECR) in one select query, 
and the affected rows are overlapped, only one transaction uses incr/decr, C1 incr affect C2 select

Test Scenario:
C1 select, C2 select, the selected rows are overlapped (based on where clause)
C1 uses INCR
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instance will be updated(increment), C2 see the instances after reevaluation

NUM_CLIENTS = 3
C1: select incr from table t1;   
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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), read_count INT);
C1: INSERT INTO t1 VALUES(1,'book1',3),(2,'book2',2),(3,'book3',1),(4,'book4',0),(5,'book5',3),(6,'book6',2),(7,'book7',0);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT title, DECR(read_count) FROM t1 WHERE id >= 2 and id <= 4 and id NOT IN (2,4); 
MC: wait until C1 ready;

C2: SELECT * FROM t1 WHERE read_count >= 1 and read_count <= 1;
/* expect: C2 doesn't need to wait, id = 3 is selected */
MC: wait until C2 ready; 

/* expect: C1 select - id = 3 is updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - no instance is selected */
C2: SELECT * FROM t1 WHERE read_count >= 1 and read_count <= 1;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 3 is updated */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
