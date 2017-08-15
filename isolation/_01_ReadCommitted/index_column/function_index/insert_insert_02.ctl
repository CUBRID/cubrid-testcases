/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
insert many column at the same time
A: insert into ... select ... from ...
B: insert one row
there is overlap

NUM_CLIENTS = 2
C1: insert into t(col) select 'a' from db_class a,db_class b,db_class c;
C2: insert into t values(2,'b'); --expected failed
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: insert into t values(1,'a'); 
C1: insert into t values(2,'a '); 
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: insert into t select t.* from (select sleep(1)) x, t where trim(col)='a';
MC: wait until C1 ready;
C2: insert into t values(2,'a');
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;

/* expected (1,'a')(2,'a ')(1,'a')(2,'a ')(2,'a')*/
C2: select * from t where trim(col)='a' order by 1;
C2: commit;

C2: quit;
C1: quit;

