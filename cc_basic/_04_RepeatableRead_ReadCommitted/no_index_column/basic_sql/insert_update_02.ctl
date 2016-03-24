/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_02.ctl
Author: Rong Xu
Test Point:
Reading queries can only have a look at data committed before the queries began
C2 begin before C1, C1 insert and commit, C2 update C1 insert data

NUM_CLIENTS = 2
C2: insert(4);
C1: insert(3);
C1: commit;
C2: update t set id=2 where id=3; --update successfully
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: insert into t values(4,'abc');
MC: wait until C2 ready;
C1: insert into t values(3,'abc');
C1: commit work;
MC: wait until C1 ready;

C2: update t set id=2 where id=3;
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;

