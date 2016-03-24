/*
Test Case: delete with lob & update with lob
Priority: 1
Reference case:
Isolation Level: Read Committed
Author: Ray

Test Plan: 
Test MVCC behaviors for 'LOB' database within common index schema 

Test Scenario:
C1 update, C2 update the updated rows are overlapped
C1 commit, C2 commit
Metrics: data size = small, where clause = simple, index = single, DELETE state = single table

Test Point:
1) C2 will be waiting for C1 (Locking Test)
2) C1 C2 can see its own data changes since the data is uncommitted after the query started. (Visibility Test)
3) C2 can see the updated value after C1 committed

NUM_CLIENTS = 3
C1: insert into t1;  
C2: insert into t1;  
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
C1: CREATE TABLE t1(id INT, content CLOB);
C1: INSERT INTO t1 VALUES (1, CHAR_TO_CLOB('test lob 1')),(2, CHAR_TO_CLOB('test lob 2'));
C1: CREATE INDEX idx on t1(id);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE CHAR_TO_CLOB(content) LIKE '%test lob 1%';
MC: wait until C1 ready;

C2: UPDATE t1 SET content = CHAR_TO_CLOB('test lob 2') WHERE CHAR_TO_CLOB(content) LIKE '%test lob 1%';
/* expect: no transactions need to wait */
MC: wait until C2 blocked;
C1: SELECT id, CLOB_TO_CHAR(content) FROM t1;
C1: COMMIT;

MC: wait until C2 ready;
/* expect: C2 - 0 rows updated, the id=1 is deleted */
C2: SELECT id, CLOB_TO_CHAR(content) FROM t1;
MC: wait until C2 ready;
C2: commit;

/* expect: the instances of id = 1 is deleted */
C3: SELECT id, CLOB_TO_CHAR(content) FROM t1;
MC: wait until C3 ready;


C1: quit;
C2: quit;
C3: quit;

