/*
Test Case: select & insert
Priority: 1
Reference case: 
Author: Ray

Test Plan: 
Test concurrent SELECT/INSERT transactions in MVCC (with NOT NULL constraint)

Test Scenario:
C1 select, C2 insert
C1 where clause is on index column (i.e. index scan)
C1 commit, C2 commit
Metrics: index = single index(unique), data size = small, where clause = simple, schema = single table

Test Point:
1) C1 and C2 do not need to wait (Locking Test)
2) C1 instances should be selected from its original snapshot
   C2 instances should be inserted (Visibility Test)

NUM_CLIENTS = 3
C1: select from table t1;  
C2: insert into table t1;  
C3: select on table t1; C3 is used to check for the updated result
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
C1: CREATE TABLE t1(id INT NOT NULL UNIQUE, col VARCHAR(10), tag VARCHAR(2));
C1: CREATE UNIQUE INDEX idx_id on t1(id);
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

C2: INSERT INTO t1 VALUES(8,'xyz','H');
/* expect: no transactions need to wait */
MC: wait until C2 ready;

/* expect: C1 select - all instances are selected (7 rows) */
C1: SELECT * FROM t1 order by 1,2;
MC: wait until C1 ready;

/* expect: C2 select - id = 8 is inserted */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect: C1 select - 8 rows data are returned */
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: 8 rows data are selected  */
C3: SELECT * FROM t1 order by 1,2;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;

