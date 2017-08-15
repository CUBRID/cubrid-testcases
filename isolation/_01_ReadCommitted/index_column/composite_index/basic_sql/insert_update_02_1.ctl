/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
C2 begin, C1 begin,C2 update C1 committed insert to the value same as C2 insert
unique index

NUM_CLIENTS = 2
C2: insert into t values('2014-01-01 10:10:10','abc');
MC: wait until C2 ready;
C1: insert into t values('2014-01-01 10:00:20','abc');
C1: commit work;
expected update failed
C2: update t set id='2014-01-01 10:10:10' and where id='2014-01-01 10:00:20';
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id timestamp,col varchar(10));
C1: create unique index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: insert into t values('2014-01-01 10:10:10','abc');
MC: wait until C2 ready;
C1: insert into t values('2014-01-01 10:00:20','abc');
C1: commit work;
MC: wait until C1 ready;

/* expected update failed */
C2: update t set id='2014-01-01 10:10:10' where id='2014-01-01 10:00:20';
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
