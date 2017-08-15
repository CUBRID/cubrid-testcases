/*
Test Case: delete & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
one user insert, another user delete the same value

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
C1: insert into t values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;
/* expect delete one row */
C2: delete from t where trim(col)='a';
MC: wait until C2 ready;
/* expect no value */
C2: select * from t order by 1;
C2: commit work;
MC: wait until C1 ready;

/* expect 2 rows */
C1: select * from t order by 1;
MC: wait until C1 ready;
C1: commit;

/* expected (1,'a') */
C2: select * from t where trim(col)='a';
C2: commit;

C2: quit;
C1: quit;

