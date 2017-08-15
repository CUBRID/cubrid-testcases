/*
Test Case: insert & select
Priority: 1 
Reference case: 
Author: Rong Xu
Test Point:
insert into ... select ... from ...

NUM_CLIENTS = 2
C1: insert into t values(2,'abc');
C1: commit;
C2: insert into t2 select * from t order by 1; -- 2 will not insert into t2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id desc);
C1: insert into t values(1,'abc');
C1: insert into t values(3,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;

/* expected (1,abc)(3,abc) */
C2: select * from t where id>0 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

/* expected 2 rows inserted */
C2: insert into t select * from t where id>0;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t where id<10 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

