/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent UPDATE/DELETE transactions in MVCC if using string function 
String Function(single): REVERSE

Test Scenario:
C1 update, C2 delete, the affected rows are not overlapped (based on where clause)
C1 update does affect C2 delete
C2 takes a long time (finished after C1 completed)
C1 uses REVERSE and C2 uses REVERSE
C1,C2 where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = function index(REVERSE), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 instances will be updated first 
   C2 instances will be deleted based on its own snapshot (Visibility Testing)

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
C1: CREATE TABLE t1(id INT, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_col_reverse on t1(REVERSE(col));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'deabcvd','B'),(3,'ghi','C'),(4,'jklhi','D'),(5,'xabc','D'),(6,'pqr','F'),(7,'stu','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET col = 'abcde' WHERE REVERSE(col) LIKE 'ih%'; 
C2: DELETE FROM t1 WHERE REVERSE(col) LIKE '%cba%' and sleep(2)=0; 
/* expect: no transactions need to wait, assume C1 finished before C2 */
MC: wait until C1 ready;
/* expect: C1 select - id = 3,4 are updated */
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
/* expect: C2 finishes execution after C1 completed, 3 rows deleted message, C2 select - id = 1,2,5(C2) are deleted, id = 3,4(C1) are updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 3,4 are updated, id = 1,2,5 are deleted */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
