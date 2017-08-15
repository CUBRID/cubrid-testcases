/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_02.ctl
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
one user insert uncommitted, another user select all rows on one index nodes

NUM_CLIENTS = 2
C1: insert into t values(2,'ab');
C2: select * from t where LENGTH(col)=2; -- can not see C1's value
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: insert into t values(1,'ab');
C1: insert into t values(3,'ac');
C1: insert into t values(7,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'ab');
MC: wait until C1 ready;
C2: select * from t where LENGTH(col)=2;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

