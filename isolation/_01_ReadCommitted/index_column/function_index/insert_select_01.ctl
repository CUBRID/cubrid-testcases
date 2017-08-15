/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_01.ctl
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
one user insert uncommitted, another user select all rows in the same index nodes

NUM_CLIENTS = 2
C1: insert('a ');
C2: select * from t where trim(col)='a' order by 1; --'a ' is invisable
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(3,'a ');
C1: insert into t values(7,' a');
C1: create index idx on t(trim(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'a ');
MC: wait until C1 ready;

/* (2,'a ') is not visable */
C2: select * from t where trim(col)='a' order by 1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

