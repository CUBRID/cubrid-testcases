/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/composite_index/basic_sql/update_delete_07.ctl
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are not overlapped initially (with composite index),
but C1's updated results affect the C2's deleting instances

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped initially (based on where clause) 
C1's updated results do affect all the C2's deleting instances
C1 C2's where clauses are on index (index scan)  
C1 commit updates index columns
C1 commit, C2 commit
Metrics: schema = single table, index = composite index, data size = small, where clause = simple

Test Point:
1) C1 and C2 will not be waiting 
2) C1 instances should be updated, C2 instances should be deleted based on the original search condition  

NUM_CLIENTS = 3
C1: update table t1;  
C2: delete from table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_id_col on t1(id,col) with online parallel 3;
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd', id = 0 WHERE id > 5;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id < 1;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 6,7 are updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 6,7 are updated, no instance is deleted */
C2: SELECT * FROM t1 order by 1,2,3;
C2: DELETE FROM t1 WHERE col = 'abcd' or id < 1;
/* expect: 2 rows deleted message, C2 select - id = 6,7 are deleted */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;

/* expect: id = 6,7 are deleted */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
