/*
Test Case: delete & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/multiple_pk/delete_delete_12.ctl
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with multiple pk schema)

Test Scenario:
The primary key is created on all(in this case: 2) the columns of the table
C1 delete, C2 delete, the affected rows are overlapped
C1 delete instances are included in the instances of C2 delete 
C1 where clause is on multiple pks, C2 where clause is on single pk 
C1 commit, C2 commit
Metrics: schema = multi-pk, data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C2 needs to wait C1 completed
2) The instances of C1 will be deleted, the overlapped C2 instances won't be deleted but the remained(non-overlapped) instances will 
   (i.e. the version will be updated, the C2 search condition is partially satisfied)

NUM_CLIENTS = 3
C1: delete from table t1;  
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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), PRIMARY KEY(id, col));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,'ghi'),(4,'jkl'),(5,'mno'),(6,'pqr'),(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 4 and col != 'mno' and col != 'abc';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id >= 3;
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 4,6 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 3 rows deleted message should generated once C2 ready, C2 select - id = 3,4,5,6,7 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: all the instances except id = 3,4,5,6,7 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;