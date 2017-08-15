/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
unique index

NUM_CLIENTS = 2
C1: insert into t values('2014-01-01 10:00:00','abc');
C2: update t set id='2014-01-01 10:00:00' where id='2014-01-01 10:00:20'; --block, violate unique constraint
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id timestamp,col varchar(10));
C1: create unique index idx on t(id,col);
C1: insert into t values('2014-01-01 10:00:20','abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expected update failed */
C1: insert into t values('2014-01-01 10:00:00','abc');
MC: wait until C1 ready;
C2: update t set id='2014-01-01 10:00:00' where id='2014-01-01 10:00:20';
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: select * from t order by 1;
C2: commit;

C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

