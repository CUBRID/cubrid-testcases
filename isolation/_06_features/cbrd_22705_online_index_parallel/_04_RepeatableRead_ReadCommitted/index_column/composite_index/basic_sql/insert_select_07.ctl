/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_13.ctl
Author: Rong Xu
Test Point:
insert into ... select ... from ...

NUM_CLIENTS = 2
C1: insert into t values(2,'abc');
C2: insert into t2 select * from t order by 1; -- 2 will not insert into t2
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
C1: drop table if exists t1;
C1: create table t1(id int,col varchar(10));
C1: create index idx2 on t1(id,col) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;

C2: insert into t1 select * from t where id>0 order by 1;
C2: select * from t where id<10 order by 1,2;
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

C2: commit;
C2: select * from t where id<10 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

