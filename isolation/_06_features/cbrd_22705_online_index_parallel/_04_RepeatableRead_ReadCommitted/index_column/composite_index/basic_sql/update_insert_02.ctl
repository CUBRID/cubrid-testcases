
/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
A begin update
     B insert a value conflict with new updated value which has not been updated
     B commit
A commit

NUM_CLIENTS = 2
C1: update t set col='def' where id >0 and sleep(1)=0; -- expected failed, conflict with 3,def
C2: insert into t values('3','def');
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id,col) with online parallel 7;
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(3,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col='def' where id >0 and sleep(1)=0;
MC: wait until C1 ready;
C2: insert into t values('3','def');
MC: wait until C2 blocked;
C1: commit;

MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;
