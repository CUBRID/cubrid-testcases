/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_17.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
insert many column at the same time
A: insert into ... select ... from ...
B: insert one row
there is overlap

NUM_CLIENTS = 2
C1: insert into t values(2,'b');
C2: insert into t(col) select 'a' from db_class a,db_class b,db_class c;
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id) with online parallel 7;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'b');
MC: wait until C1 ready;

MC: wait until C2 ready;

C2: insert into t(id,col) select rownum,'a' from db_class a,db_class b,db_class c where rownum <= 1000;
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: commit;          
C2: select count(*) from t;
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;

