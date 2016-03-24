/*
Test Case: update & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/basic_sql/update_delete_06.ctl
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with single index)
and C1's updated results do not affect the C2's deleting instances

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1's updating the instances contain the C2's deleting instances
C1's updated results do not affect the C2's deleting instances
C1 where clause is on index (i.e. index scan), C2 where clause is not on index (heap scan)
C1 rollback, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances won't be updated since C1 rollback, C2 instances will be deleted
   (i.e.the version won't be updated, the search condition of C2 is still satisfied) 

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd' WHERE (id BETWEEN 3 AND 5) and col != 'mno' or col = 'pqr';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE tag >= 'C' and tag <= 'D';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 3,4,6 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
/* expect: 2 rows deleted message should generated once C2 ready, C2 select - id = 3,4 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: no instance is updated, id = 3,4 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

