/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_03.ctl
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
one user insert uncommitted, another select the uncommitted data

NUM_CLIENTS = 2
C1: insert(2);
C2: select * from t order by 1 where id=2; -- no row 
C1: commit;
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
C1: create index idx on t(id,col) with online parallel 3;
C1: insert into t values(1,'abc');
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: select * from t where id=2 order by 1;
MC: wait until C2 ready;
C1: commit work;
C2: commit;
C2: select * from t where id>0 order by 1;
C2: commit;

C2: quit;
C1: quit;

