/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC if using string function
String Function(single): TRIM

Test Scenario:
C1 delete, C2 delete, the affected rows are overlapped (based on where clause)
C1 uses TRIM and C2 uses TRIM
C1 delete instances equal to C2 delete instances
C1,C2 where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = function index(TRIM), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances will be deleted 
   C2 instances will be deleted after reevaluation (Visibility/Reevaluation Testing) 

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: delete from table t1; 
C3: select on table t1; C3 is used to check for the updated results 
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
C1: CREATE INDEX idx_col_trim on t1(TRIM(col));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'a b c','B'),(3,' abc ','C'),(4,'a bc ','D'),(5,'abc ','D'),(6,'cde ','F'),(7,' cde','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE TRIM(col) = 'abc'; 
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE TRIM(col) LIKE '%abc%'; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,3,5 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 0 row deleted message once C2 ready, C2 select - id = 1,3,5(C1) are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,3,5 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
