/*
Test Case: alter table with lob & insert into 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test locking behavior if transaction operates an invalid ddl (with lob) in MVCC

Test Scenario:
C1 alter table, C2 insert into, the table name is not overlapped

Test Point:
1) C2 will be waiting (Locking Test)
2) C2 can see C1 effect after C1 committed (Visibility Test)

NUM_CLIENTS = 3
C1: create table t1;  
C2: create table t2;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1 (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: ALTER TABLE t1 ADD CONSTRAINT content_unique UNIQUE(content);
/* an error message should be generated */
MC: wait until C1 ready;
C2: insert into t1(doc_id) values('doc_1');
/* expect: C2 needs to wait since SCH_M_LOCK*/
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
/* expect: C2 select - doc_1 should be inserted */
C2: SELECT * FROM t1;
C2: describe t1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
