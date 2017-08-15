/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are overlapped (with single index)

Test Scenario:
C1 delete, C2 update, the affected rows are overlapped (based on where clause)
C1's deleting the instances intersect with the C2's updating instances
C2 try to update an unique index column to a duplicate key which is C1 try to deleting 
C1 where clause is on index (index scan), C2 where clause is not on index (heap scan) 
C1 commit, C2 commit
Metrics: data size = small, index = single index(Unique), where clause = no, schema = single table

Test Point:
1) C2 needs to wait until C1 completed
2) All the C1 instances will be deleted, the C2 instance will be updated (duplicate key has been deleted) 
   (i.e.the version will be updated, the C2 search condition is satisfied) 

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
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
C1: CREATE TABLE t1(id INT UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id IN (2,4,6);
MC: wait until C1 ready;
C2: UPDATE t1 SET id = 4, col = 'xyz' WHERE tag BETWEEN 'C' AND 'D' and col != 'jkl';
/* expect: C2 needs to wait once C1 completed */
MC: wait until C2 blocked;
/* expect: C1 select - id = 2,4,6 are deleted */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
/* expect: 1 row (id=3)updated message should generated once C2 ready, C2 select - id = 3 is updated */
MC: wait until C2 ready;
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: id = 2,4,6 are deleted, id = 3 is updated */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
