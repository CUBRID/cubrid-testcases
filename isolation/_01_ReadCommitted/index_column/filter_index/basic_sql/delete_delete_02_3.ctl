/*
Test Case: delete & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/filter_index/basic_sql/delete_delete_02.ctl
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped (with filtered index)

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1,C2 where clause uses filtered index (index scan - partially)
A portion of C1,C2 instances are using filtered index scan
C1 rollback, C2 commit
Metrics: data size = small, index = single filtered index, where clause = simple, DELETE state = single table deletion

Test Point:
1) C2 needs to wait until C1 completed 
2) C1 instances shouldn't be deleted since C1 rollback
   all C2 instances should be deleted

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: CREATE INDEX idx_id on t1(id) where id >= 3 and id <= 4;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id = 3 or id = 5 USING INDEX idx_id;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id = 3 or id = 2 USING INDEX idx_id;
/* expect: C2 needs to wait until C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 3 is deleted, id = 5 is still existed */
C1: SELECT * FROM t1 order by 1,2;
C1: rollback;
/* expect: 1 row (id=3)deleted message should generated once C2 ready, C2 select - id = 3 is deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 3 is deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
