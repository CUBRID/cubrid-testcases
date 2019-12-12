/*
Test Case: insert & update
Priority: 2 
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_02.ctl
Author: Rong Xu
Test Point:
Reading queries can only have a look at data committed before the queries began
C2 begin, C1 begin,C2 update C1 committed insert

NUM_CLIENTS = 2
C2: insert into t values('2014-01-01 10:10:00','abc');
MC: wait until C2 ready;
C1: insert into t values('2014-01-01 10:00:01','def');
C1: commit work;
C2: update t set id='2014-01-01 10:10:01' and col='def' where id='2014-01-01 10:00:00'; --expected update successfully
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id timestamp,col varchar(10));
C1: create index idx on t(id,col) with online parallel 3;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values('2014-01-01 10:10:00','abc');
MC: wait until C1 ready;
C2: insert into t values('2014-01-01 10:00:01','def');
C2: commit work;
MC: wait until C2 ready;
C1: update t set id='2014-01-01 10:10:01',col='def' where id='2014-01-01 10:00:00';
C1: commit;

C1: select * from t order by 1;
C1: commit;

C2: quit;
C1: quit;

