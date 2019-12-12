/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data or changes committed after the query started are never seen

B begin insert
                   A begin select
                   B commit
A end select
A commit

NUM_CLIENTS = 2
C1: insert into t values(1,1);
C2: select * from t where col=1 and sleep(1)=0; --expected can not select C1 inserted data
MC: sleep 1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: insert into t select rownum%100,rownum from db_class a,db_class b where rownum <= 500;
C1: create unique index idx on t(id,col) with online parallel 7;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,2);
C2: select * from t where id=1 and sleep(1)=0;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
