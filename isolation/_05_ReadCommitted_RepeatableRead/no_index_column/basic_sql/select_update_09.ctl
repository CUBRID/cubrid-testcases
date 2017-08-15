/*
Test Case: update & select
Priority: 1
Reference case:
Author: Bobo

Test Point:
1. Reading transactions can only have a look at data committed before the transactions began
2. changes committed after the transaction started are never seen

NUM_CLIENTS = 2
C1: select three times - before C2 begin, after C2 commit, after C1 commit. 
C2: update, commit after C1's transaction start
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'ghijk');insert into t1 values(4,'lmn');insert into t1 values(5,'opq');insert into t1 values(6,'rs');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select t1.* from t1 where (select sleep(1)) = 0 order by id;
MC: sleep 2;
C2: update t1 set id=1 where id=6;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
