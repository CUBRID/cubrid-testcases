/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC if using string function 
String Function(single): RTRIM

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 try to update an unique index to which C1 is trying to delete 
C1 uses RTRIM and C2 uses RTRIM
C1,C2's where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple indexes(PK + function), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances will be deleted, C2 instances will be updated since the duplicate key has been removed
   (Visibility/Reevaluation Testing) 

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1; 
C3: select on table t1; C3 is used to check the updated results 
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
C1: CREATE INDEX idx_col_rtrim on t1(RTRIM(col));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,' def','C'),(4,'abc ','D'),(5,'def ','D'),(6,' abc','F'),(7,' def ','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE RTRIM(col) = 'abc'; 
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 1 WHERE RTRIM(col) = 'def' and id != 2;
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,4 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=5)updated message once C2 ready, C2 select - id = 5(C1) is updated, id = 1,4(C2) are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,4 are deleted, id = 5 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;