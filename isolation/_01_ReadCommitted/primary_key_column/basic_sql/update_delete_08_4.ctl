/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/update_delete_08.ctl
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped initially (with pk schema),
but C1's updated results affect the C2's deleting instances

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped initially (based on where clause) 
C1's updating the instances are included in the C2's deleting instances
C1's updated results do affect a portion of the C2's deleting instances
C1,C2's where clauses are on pk (i.e. index scan)
C1 updates the PK column
C1 commit, C2 commit
Metrics: schema = single table with pk, data size = small, where clause = simple

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be updated, C2 instances which still satisfy the search condition will be deleted but others will not 
   (i.e.the version will be updated, the search condition of C2 is partially satisfied) 

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcd', id = 0 WHERE id >= 5 and col != 'mno' and tag != 'F';
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id >= 5;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 7 is updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows (id=5,6)deleted message should generated once C2 ready, C2 select - id = 5,6 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: id = 7 is updated, id = 5,6 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

