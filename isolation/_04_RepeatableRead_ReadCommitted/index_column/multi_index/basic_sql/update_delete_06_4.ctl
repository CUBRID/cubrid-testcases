/*
Test Case: update & delete 
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/multi_index/basic_sql/update_delete_06.ctl
Author: Ray

Test Plan: 
Test UPDATE/DELETE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with multiple indexes)

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped 
C1's updating the instances intersect with the C2's deleting instances
C1's updated results do not affect the C2's deleting instances
C1 where clause is not on index (i.e. heap scan), C2 where clause is on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes(PK + Unique + Composite index), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be updated, C2 instances will be deleted

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
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2), description VARCHAR(100));
C1: CREATE UNIQUE INDEX idx_col on t1(col);
C1: CREATE INDEX idx_id_tag on t1(id, tag);
C1: INSERT INTO t1 VALUES(1,'abc','A','hello');INSERT INTO t1 VALUES(2,'def','B','morning');INSERT INTO t1 VALUES(3,'ghi','C','good');INSERT INTO t1 VALUES(4,'jkl','D','test');INSERT INTO t1 VALUES(5,'mno','E',NULL);INSERT INTO t1 VALUES(6,'pqr','F',NULL);INSERT INTO t1 VALUES(7,'stu','G','');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET tag = 'X', description = 'modified' WHERE description IS NULL;
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE id = 6 or col = 'abc';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 5,6 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect: 3 rows(id=1,6,7) deleted message should generated once C2 ready, C2 select - id = 1,6,7 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 5 is updated, id = 1,6,7 are deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
