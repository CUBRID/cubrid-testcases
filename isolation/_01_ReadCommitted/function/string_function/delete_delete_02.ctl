/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC if using string function  
String Function(multiple): LOWER/LEFT

Test Scenario:
C1 delete, C2 delete, the affected rows are not overlapped (based on where clause)
C1 uses LOWER and C2 uses LEFT
C1,C2 where clauses are on index (index scan)
C1 commit, C2 commit
Metrics: data size = small, index = multiple function index(LOWER/LEFT), where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C1 instances will be deleted, C2 instances will be deleted (Visibility Testing) 

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
C1: CREATE INDEX idx_col_lower on t1(LOWER(col));
C1: CREATE INDEX idx_col_left on t1(LEFT(col,4));
C1: INSERT INTO t1 VALUES(1,'abcdefg','A'),(2,'ABCDEFG','B'),(3,'abcdxyz','C'),(4,'axbyczd','D'),(5,'ABCEWRx','D'),(6,'cdefihj','F'),(7,'CDEFxyz','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE LOWER(col) LIKE 'cdef%'; 
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE LEFT(col,4) = 'abcd'; 
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 6,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,3 are deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

/* expect: C2 select - id = 1,3,6,7 are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: the instances of id = 1,3,6,7 are deleted */
C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
