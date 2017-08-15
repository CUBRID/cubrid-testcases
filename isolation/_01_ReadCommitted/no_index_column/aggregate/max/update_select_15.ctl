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
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(1,'ijk'),(3,'lmn'),(4,'lmn');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=5 where id=3;
MC: wait until C1 ready;
/*  get 3 where col=abc and get 4 where col=lmn*/
C2: select max(id),col from (select sleep(10)) x, t1 group by col;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
/* get 5 where col=abc and col=lmn*/
C2: select max(id),col from t1 group by col;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
