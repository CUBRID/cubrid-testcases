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
C1: insert into t1 values(2,'abc'),(3,'def'),(4,'abc'),(2,'ijk'),(3,'lmn');
C1: create index idx on t1(id);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=1 where id=2;
MC: wait until C1 ready;
/*  get 2 */
C2: select min(id) from t1 where sleep(2)=0 and id>0;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
/* get 1 */
C2: select min(id) from t1 where id>0;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
