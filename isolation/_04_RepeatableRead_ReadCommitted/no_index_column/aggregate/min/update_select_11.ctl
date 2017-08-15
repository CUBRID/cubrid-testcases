/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. changes committed after the query started are never seen

NUM_CLIENTS = 2
C1: update, commit after C2's query start
C2: select twice - before C1 commit, after C1 commit
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
MC: wait until C1 ready;
/*  get 2 */
C2: select min(id) from t1 where (select sleep(10)) = 0;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
/* get 1 */
C2: select min(id) from t1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
