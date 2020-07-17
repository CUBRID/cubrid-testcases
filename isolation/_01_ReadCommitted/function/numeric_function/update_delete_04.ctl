/*
Test Case: update & delete 
Priority: 1
Reference case:
Author: Ray
Function: FLOOR

Test Plan: 
Test MVCC UPDATE/DELETE scenarios (locks - X_LOCK on instance) if using numeric function FLOOR in queries,
and the affected rows are overlapped, C1 update doesn't affect C2 delete

Test Scenario:
C1 update, C2 delete, the selected rows are overlapped (based on where clause)
C1 update doesn't affect C2 delete
C1 uses FLOOR and C2 uses FLOOR
C1,C2's where clauses are on index(index scan)
C1 commit, C2 commit
Metrics: data size = small, index = single index, where clause = simple, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) C1 instances will be updated, C2 instances will be deleted after reevaluation 

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
C1: CREATE TABLE t1(id INT, title VARCHAR(10), price DECIMAL);
C1: CREATE INDEX idx_price on t1(price);
C1: INSERT INTO t1 VALUES(1,'book1',30.16),(2,'book2',31.23),(3,'book3',30.99),(4,'book4',31.66),(5,'book5',29.87),(6,'book6',29.01),(7,'book7',32.04);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t1 SET title = 'unknown_bo' WHERE FLOOR(price) = 31; 
MC: wait until C1 ready;
C2: DELETE FROM t1 WHERE FLOOR(price) = 30 or id = 3; 
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,3 are updated */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 3 rows (id=1,3,5)deleted message once C2 ready, C2 select - id = 1,3,5 are deleted */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: the instances of id = 2 is updated, id = 1,3,5 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
