/*
Test Case: delete & insert
Priority: 1 
Reference case: 
Author: Rong Xu

Test Point:
one user insert and then delete in-place, another delete the whole table
there is lock overlap

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
C1: create index idx on t(LENGTH(col));
C1: insert into t values(2,'abcd');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'efg');
MC: wait until C1 ready;
/* expect delete (2,abc) */
C2: delete from t where LENGTH(col)>0;
MC: wait until C2 ready;

/* expect delete (1,efg) */
C1: delete from t where LENGTH(col)>0;
MC: wait until C1 blocked;

/* expected no value */
C2: select * from t order by 1;
C2: commit;
MC: wait until C1 ready;

/* expected delete 1 row,select no value */
C1: select * from t order by 1;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;

