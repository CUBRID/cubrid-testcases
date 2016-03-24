/*
Test Case: delete & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_update_06.ctl
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with pk schema)

Test Scenario:
C1 delete, C2 update, the affected rows are overlapped
C1's deleting the instances are included in the C2's updating instances
C1,C2's where clauses are not on pk (heap scan)
C1 commit, C2 commit
Metrics: schema = single table with pk, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed
2) All the C1 instances will be deleted, the overlapped C2 instances won't be updated but the remained instances (non-overlapped) will be 
   (i.e.the version will be updated, the C2 search condition is partially satisfied) 

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE tag = 'B' or col = 'ghi' or col = 'jkl';
MC: wait until C1 ready;
C2: UPDATE t1 SET col = 'abcd' WHERE col = 'def' or tag = 'A' or tag = 'F';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3,4 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 row (id=1,6) updated message should generated once C2 ready, C2 select - id = 1,6 are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: id = 2,3,4 are deleted, id = 1,6 are updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
