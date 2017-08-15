/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
A: insert into ... select ... from ...
B: insert one row, commit
there is overlap

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a'); 
C2: insert into t values(2,'a ');
C2: commit;
MC: wait until C2 ready;

C1: insert into t select * from t where trim(col)='a';
/* expect (1,a) (1,a)*/
C1: select * from t order by 1,2; 
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

