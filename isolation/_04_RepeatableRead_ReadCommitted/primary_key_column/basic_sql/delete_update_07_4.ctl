/*
Test Case: delete & update 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_update_07.ctl
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with pk schema)

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 try to update the pk column to a duplicate key which is C1 try to deleting
C1 delete single row data, C2 update single row data 
C1,C2's where clauses are not on pk column (heap scan)
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, schema = single table with pk

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be deleted, C2 instances will be updated (since the duplicate key is deleted)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A');INSERT INTO t1 VALUES(2,'def','B');INSERT INTO t1 VALUES(3,'ghi','C');INSERT INTO t1 VALUES(4,'jkl','D');INSERT INTO t1 VALUES(5,'mno','E');INSERT INTO t1 VALUES(6,'pqr','F');INSERT INTO t1 VALUES(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE col IN ('def','mno','pqr');
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 5,col = 'xyz' WHERE tag >= 'C' and tag <= 'D' and col != 'ghi';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,5,6 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=4) updated message should generated once C2 ready, C2 select - id = 4 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: id = 2,5,6 are deleted, id = 4 is updated */
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
