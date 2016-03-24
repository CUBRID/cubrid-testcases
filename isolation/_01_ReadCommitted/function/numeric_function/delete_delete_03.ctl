/*
Test Case: delete & delete 
Priority: 1
Reference case:
Author: Ray
Function: CEIL

Test Plan: 
Test MVCC DELETE scenarios (locks - X_LOCK on instance) if using numeric function CEIL in delete queries, 
and the affected rows are overlapped

Test Scenario:
C1 delete, C2 delete, the selected rows are overlapped (based on where clause)
C1 uses CEIL and C2 uses CEIL
C1 commit, C2 commit
Metrics: data size = small, index = no index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed 
2) C1 instances will be deleted 
   C2 instances will be deleted after reevaluation 

NUM_CLIENTS = 3
C1: delete from table t1;   
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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), price DECIMAL);
C1: INSERT INTO t1 VALUES(1,'book1',30.16),(2,'book2',31.23),(3,'book3',30.99),(4,'book4',31.66),(5,'book5',29.87),(6,'book6',31.89),(7,'book7',32.04);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE CEIL(price) = 31.00; 
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE CEIL(price) >= 30 and CEIL(price) <= 31; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 2 rows (id=1,5)deleted message once C2 ready, C2 select - id = 1,5 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 1,2,3,5 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
