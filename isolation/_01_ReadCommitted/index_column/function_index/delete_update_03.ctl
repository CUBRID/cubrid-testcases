/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with function index)
C2 update affect C1 delete, C1 finishes execution after C2 commit since C1 takes a long time

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 update does affect C1 delete
C1 finishes execution after C2 commit since C1 takes a long time
C1,C2 where clause uses function index (i.e. index scan)
C2 commit, C1 commit
Metrics: data size = small, index = multiple function indexes(ABS+LENGTH), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances should be updated first, C1 instances should be deleted based on its original snapshot

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'a','A'),(-1,'bb','B'),(2,'ccc','C'),(3,'ddd','D'),(-3,'eeee','E'),(4,'ff','F'),(-4,'g','G');
C1: CREATE INDEX idx_id_abs on t1(ABS(id));
C1: CREATE INDEX idx_col_length on t1(LENGTH(col));
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE ABS(id) <= 2;
MC: wait until C1 ready;

C2: UPDATE t1 SET id = 2 WHERE LENGTH(col) = 4;
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C2 select - id = -3 is updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: C1 finishes execution after C2 commit, 3 rows (id=1,-1,2) deleted message should be generated, C2 select - id = 1,-1,2 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = -3 is updated, id = 1,-1,2 are deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
