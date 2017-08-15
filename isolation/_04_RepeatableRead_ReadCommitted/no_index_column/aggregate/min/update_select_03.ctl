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
C1: update and select on table t1
C2: select on table t1 before C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(2,'abc');insert into t1 values(3,'def');insert into t1 values(4,'abc');insert into t1 values(5,'ijk');insert into t1 values(5,'lmn');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=1 where id=5;
/* C1 get 1; C2 get 2*/
C1: select min(id) from t1;
MC: wait until C1 ready;

C2: select min(id) from t1;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
