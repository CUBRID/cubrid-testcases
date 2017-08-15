/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC if using string function 
String Function(multiple): CHAR_LENGTH/TRIM

Test Scenario:
C1 update, C2 delete, the selected rows are overlapped (based on where clause)
C1 update doesn't affect C2 delete
C1 uses CHAR_LENGTH and C2 uses CHAR_LENGTH(TRIM)
C1,C2's where clauses are on index(index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function indexes(CHAR_LENGTH+TRIM), where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances will be updated, C2 instances will be deleted after reevaluation (Visibility/Reevaluation Testing)

NUM_CLIENTS = 3
C1: update table t1;   
C2: delete from table t1; 
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
C1: CREATE INDEX idx_col_trim on t1(TRIM(col));
C1: CREATE INDEX idx_col_length on t1(CHAR_LENGTH(col));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,' def ','C'),(4,'abc ','D'),(5,'def ','D'),(6,' abc','F'),(7,' def','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET tag = 'X' WHERE TRIM(col) = 'def'; 
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE CHAR_LENGTH(col) >= 5; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3,5,7 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=3)deleted message once C2 ready, C2 select - id = 3(C2) are deleted, id = 2,5,7(C1) are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 2,5,7 are updated, id = 3 is deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;