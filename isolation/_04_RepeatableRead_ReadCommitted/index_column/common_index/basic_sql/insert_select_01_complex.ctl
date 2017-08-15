/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data or changes committed after the query started are never seen
A begin select
                   B begin insert
                   B commit
A end select
A commit

NUM_CLIENTS = 3
C1: select t.* from (select sleep(1)) x, t where col=1 order by 1,2;
MC: sleep 1;
C2: insert into t values(1,1);
C3: insert into t values(1,1);
C1: select t.* from t;
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: insert into t select rownum,rownum%100 from db_class a,db_class b where rownum <= 500;
C1: create index idx_id on t(col);
C1: create index idx_col on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select t.* from t where col=1 and (select sleep(1)) = 0 order by 1,2;
MC: sleep 1;
C2: insert into t values(1,1);
MC: wait until C2 ready;
MC: wait until C1 ready;

C3: insert into t values(1,1);
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;

C1: commit work;
C1: select t.* from t where id=1;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;
