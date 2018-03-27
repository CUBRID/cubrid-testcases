/*
Test Case: delete & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/no_index_column/basic_sql/delete_update_03.ctl
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions overlapped

Test Scenario:
C1 delete, C2 update, the affected rows are overlapped
C1's deleting the instances are included the C2's updating instances
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait C1 completed
2) All the C1 instances will be deleted, the overlapped C2 instances won't be updated but the remained instances (non-overlapped) will be 
   (i.e.the version will be updated, the C2 search condition is partially satisfied) 

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(6,'pqr');INSERT INTO t1 VALUES(7,'abc');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE col = 'abc' or col = 'mno';
MC: wait until C1 ready;
C2: UPDATE t1 SET col = 'abcd' WHERE id >= 5 or id = 1;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,5,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
/* expect: 1 row (id=6)updated message should generated once C2 ready, C2 select - id = 6 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: the instances of id = 1,5,7 are deleted, id = 6 is updated */
C3: select * from t1 order by 1,2;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
