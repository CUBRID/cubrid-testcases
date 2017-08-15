/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DELETE/UPDATE transactions in MVCC if using string function 
String Function(multiple): LOWER/LEFT

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 update does affect C1 delete
C1 take a long time to execute(after C2 completed)
C1 uses LOWER and C2 uses LEFT(LOWER)
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait (Locking Test)
2) C2 instances will be updated first 
   C1 instances will be deleted based on its original snapshot (Visibility Testing)

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
C1: INSERT INTO t1 VALUES(1,'abcdefg','A'),(2,'ABCDEFG','B'),(3,'abcdxyz','C'),(4,'axbyczd','D'),(5,'ABCEWRx','D'),(6,'cdefihj','F'),(7,'CDEFxyz','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LOWER(col) LIKE '%abcde%' and sleep(2)=0; 
C2: UPDATE t1 SET col = 'abcde' WHERE LEFT(LOWER(col),4) = 'cdef';
/* expect: no transactions need to wait, C2 completed before C1*/
MC: wait until C2 ready;
/* expect: C2 select - id = 6,7 are updated */
C2: SELECT * FROM t1 order by 1,2,3;
C2: commit;
/* expect: C1 finishes execution after C2 commit, 2 rows deleted message, C1 select - id = 1,2(C2) are deleted, id = 6,7(C1) are updated */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2,3;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 6,7 are updated, id = 1,2 are deleted */
C3: select * from t1 order by 1,2,3;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
