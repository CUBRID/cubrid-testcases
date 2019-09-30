/*
Test Case: insert & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
unique index and function index
violate unique constraint, select by function index

NUM_CLIENTS = 1
*/

MC: setup NUM_CLIENTS = 1;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10) unique);
C1: create index idx on t(trim(col)) with online parallel 3;
C1: insert into t values(1,'a');
C1: insert into t values(2,'  a');
C1: insert into t values(3,' a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(4,'a');
/* (4,'a') should not be selected */
C1: select * from t where trim(col)='a' order by 1,2;
C1: commit;

C1: quit;

