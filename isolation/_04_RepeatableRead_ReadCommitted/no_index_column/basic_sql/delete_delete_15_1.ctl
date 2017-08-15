/*
Test Case: delete & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/no_index_column/basic_sql/delete_delete_15.ctl
Isolation Level: Read Committed
Author: Ray

Test Plan: 
Test DELETE locks (X_LOCK on instance) if the delete instances of the transactions are overlapped

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C2 deletes an empty set
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, DELETE state = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) The C1 instances will be deleted, all the C2 instances won't be deleted (Visibility Test)  

NUM_CLIENTS = 3
C1: delete from table t1;  
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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: INSERT INTO t1 VALUES(1,'abc');INSERT INTO t1 VALUES(2,'def');INSERT INTO t1 VALUES(3,'ghi');INSERT INTO t1 VALUES(4,'jkl');INSERT INTO t1 VALUES(5,'mno');INSERT INTO t1 VALUES(6,'pqr');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id IN (2,3,8);
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE id = 8;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 2,3 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - no data is deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 2,3 are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 2,3 are deleted */
MC: wait until C2 ready;

C3: select * from t1 order by 1,2;
MC: wait until C3 ready;


C3: commit;
C1: quit;
C2: quit;
C3: quit;
