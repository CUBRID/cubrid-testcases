/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/update_delete_06.ctl
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with pk schema),
and C1's updated results do not affect the C2's deleting instances

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped
C1's updating the instances contain the C2's deleting instances
C1's updated results do not affect the C2's deleting instances
C1's where clause isn't on pk (i.e. heap scan), C2's where clause is on pk (i.e. index scan)
C1 commit, C2 commit
Metrics: schema = single table with pk, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be updated, C2 instances will be deleted
   (i.e.the version will be updated, the search condition of C2 is still satisfied) 

NUM_CLIENTS = 3
C1: update table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd' WHERE col = 'jkl' or col = 'mno' or col = 'pqr';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id >= 4 and id <= 5;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 4,5,6 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows deleted message should generated once C2 ready, C2 select - id = 4,5 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: id = 6 is updated, id = 4,5 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;