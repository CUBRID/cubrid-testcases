/*
Test Case: delete & delete
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DELETE transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 delete, C2 delete, the affected rows are not overlapped (based on where clause)
C1, C2 where clause are all on NOT NULL column (i.e. index scan)
C1 commit, C2 commit
Metrics: index = single index, data size = small, where clause = simple, schema = single table

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) All the data affected from C1 and C2 should be deleted (Visibility Test)

NUM_CLIENTS = 3
C1: delete from table t1;  
C2: delete from table t1;  
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
C1: CREATE TABLE t1(id INT NOT NULL, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE id >= 6;
MC: wait until C1 ready;

C2: DELETE FROM t1 WHERE id <= 2;
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 select - id = 6,7 are deleted */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;
/* expect: C2 select - id = 1,2 are deleted */
C2: SELECT * FROM t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expect: C2 select - id = 1,2(C2) 6,7(C1) are deleted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* expect: id = 1,2,6,7 are deleted */
C3: SELECT * FROM t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;



