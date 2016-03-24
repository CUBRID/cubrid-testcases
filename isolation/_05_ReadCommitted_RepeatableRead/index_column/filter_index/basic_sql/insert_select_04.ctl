/*
Test Case: insert & select
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
one user insert committed, another user select all rows

NUM_CLIENTS = 2
C1: insert(2);
C2: select * from t order by 1; -- 2 is not visable
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id) where id>1;
C1: insert into t values(1,'abc');
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: select * from t where id>1 using index idx(+);
C2: commit;
MC: wait until C2 ready;
C1: commit;

C1: quit;
C2: quit;

