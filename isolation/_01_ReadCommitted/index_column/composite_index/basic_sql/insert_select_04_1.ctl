/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
index covers all selected columns, just use index can get result
unique index

NUM_CLIENTS = 2
C1: insert into t values(2,'abc','efg');
C2: select id,col from t where id>0 and col='abc'; --expected can not see (2,abc,efg)
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10),col1 varchar(10));
C1: create unique index idx on t(id,col);
C1: insert into t values(1,'abc','def');
C1: insert into t values(3,'abc','def');
C1: insert into t values(7,'ab','def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc','efg');
MC: wait until C1 ready;

C2: select id,col from t where id>0 and col='abc';
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

