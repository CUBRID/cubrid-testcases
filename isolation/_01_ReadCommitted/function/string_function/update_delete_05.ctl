/*
Test Case: update & delete 
Priority: 1
Reference case:
Related Issue: CUBRIDSUS-14336
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC if using string function 
String Function(single): CHAR_LENGTH

Test Scenario:
C1 update, C2 delete, the affected rows are overlapped (based on where clause)
C1 update does affect C2 delete
C1 uses CHAR_LENGTH and C2 uses CHAR_LENGTH
C1 update instances contain C2 delete instances
C1,C2's where clauses are on index(index scan)
C1 commit, C2 commit
Metrics: data size = small, index = function index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed  (Locking Test)
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
C1: CREATE TABLE t1(id INT, col VARCHAR(10));
C1: CREATE INDEX idx_col_length on t1(CHAR_LENGTH(col));
C1: INSERT INTO t1 VALUES(1,'abc'),(2,'def'),(3,' def '),(4,'abc '),(5,'def '),(6,' ab'),(7,' def');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcdefg' WHERE CHAR_LENGTH(col) >= 4;  
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE CHAR_LENGTH(col) >= 5; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 3,4,5,7 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 rows (id=3)deleted message once C2 ready, C2 select - id = 3 are deleted, CUBRIDSUS-14336 */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 3 is deleted, id = 4,5,7 are updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;