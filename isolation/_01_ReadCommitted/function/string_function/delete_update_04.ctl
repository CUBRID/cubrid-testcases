/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC if using string function 
String Function(single): CONCAT

Test Scenario:
C1 delete, C2 update, the selected rows are overlapped (based on where clause)
C1 delete instances intersect with C2 update instances
C1 uses CONCAT
C1 commit, C2 commit
Metrics: data size = small, index = composite index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed (Locking Test)
2) C1 instances will be deleted, C2 instances will be updated after reevaluation (Visibility/Reevaluation Testing)

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_col_tag on t1(col,tag);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','D'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE CONCAT(col,tag) LIKE 'abc%'; 
MC: wait until C1 ready;
C2: UPDATE t1 SET col = 'abcd' WHERE tag IN ('A','B');
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 1,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=2)deleted message once C2 ready, C2 select - id = 2(C2) is updated, id = 1,7(C1) are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,7 are deleted, id = 2 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;