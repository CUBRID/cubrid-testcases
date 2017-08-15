/*
Test Case: create table with lob & create table with lob 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test concurrent DDL transactions (with lob) in MVCC

Test Scenario:
C1 create table, C2 create table, the table name is not overlapped

Test Point:
1) C1 and C2 will not be waiting (Locking Test)
2) C2 can see C1's table after C1 committed (Visibility Test)

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
C1: DROP TABLE IF EXISTS t2;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: CREATE TABLE t1 (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);
MC: wait until C1 ready;
C2: CREATE TABLE t2 (doc_id VARCHAR(64) PRIMARY KEY, content CLOB);
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C1 show tables - t1 is created */
C1: SHOW TABLES;
C1: commit;
MC: wait until C1 ready;
/* expect: C2 show tables - t1,t2 are created */
C2: SHOW TABLES;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
