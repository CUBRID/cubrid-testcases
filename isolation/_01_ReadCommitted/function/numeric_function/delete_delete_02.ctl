/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray
Function: MOD/ABS

Test Plan: 
Test MVCC DELETE scenarios (locks - X_LOCK on instance) if using mixed numeric functions in delete queries, 
and the affected rows are not overlapped

Test Scenario:
C1 delete, C2 delete, the selected rows are not overlapped (based on where clause)
C1 uses MOD and C2 uses ABS
C1,C2 where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function indexes, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances will be deleted, C2 instances will be deleted 

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: delete from table t1; 
C3: select on table t1; C3 is used to check the updated results 
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
C1: CREATE INDEX idx_id_abs on t1(ABS(id));
C1: CREATE INDEX idx_read_mod on t1(MOD(read_count,2));
C1: INSERT INTO t1 VALUES(1,'book1',3),(-1,'book2',5),(2,'book3',1),(-3,'book4',0),(4,'book5',3),(-4,'book6',2),(3,'book7',4);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ABS(id) >= 1 and ABS(id) <= 2; 
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE MOD(read_count,2) = 0; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C2 ready;

/* expect: C1 select - id = 1,-1,2 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = -3,-4,3 are deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

/* expect: all the instances except id = 4 are deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
