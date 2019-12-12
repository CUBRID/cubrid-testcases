/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test the visibility of uncommited data
1. Uncommitted data are never seen by other queries
2. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time, check update does not block select.

NUM_CLIENTS = 2
C1: update and select on the whole table
C2: select on table t1 before C1 commit, blocked
C3: verify the final result
*/


MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(4,'def');insert into t1 values(5,'ijk');insert into t1 values(6,'lmn');
C1: create index idx on t1(id) with online parallel 3;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=id+1;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where id>1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C2 ready;

C3: select * from t1 order by 1,2;
C3: commit;

C1: quit;
C2: quit;
