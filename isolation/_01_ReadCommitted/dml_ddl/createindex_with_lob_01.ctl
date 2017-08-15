/*
Test Case: create index on lob & insert into
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DDL transactions (with lob) in MVCC

Test Scenario:
C1 create index on lob column (invalid), C2 insert into

Test Point:
1) C2 will be waiting (Locking Test)
2) C2 can see C1 effects after C1 committed (Visibility Test)

NUM_CLIENTS = 3
C1: create table t1;  
C2: create table t2;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1 (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: CREATE INDEX i_doc_t_content ON t1 (content);
MC: wait until C1 ready;
C2: INSERT INTO t1(doc_id) VALUES('doc_1'); 
/* expect: C2 needs to wait since SCH_M Lock */
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
/* expect: C2 show tables - t1 are created */
C2: describe t1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
