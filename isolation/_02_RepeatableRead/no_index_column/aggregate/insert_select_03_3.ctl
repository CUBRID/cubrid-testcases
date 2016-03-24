/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/insert_select_01.ctl
Author: Lily

Test Point:
there is expr and subquery in min max, there are unvacuumed data, and uncommitted update and insert at the same time
C1 update begin
               C2 insert begin
                              C3 select begin
               C2 commit
C1 commit
                             C3 select begin

NUM_CLIENTS = 3
C3: select min(t1.id),max(t1.col) from t t1 left outer join (select min(t.col) as col from t where id>5) as t2 on t1.id=t2.col group by t2.col;
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint,col varchar(10));
C1: insert into t select rownum,rownum%10 from db_class a,db_class b,db_class c,db_class d limit 100000;
C1: commit;
C1: update t set col=col-1;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set id=col-1 where id%2=0;
MC: wait until C1 ready;
C2: insert into t select t.* from (select sleep(5)) x, t where id%3=0;
C3: select min(t1.id),max(t1.col) from t t1 left outer join (select min(t.col) as col from t where id>5) as t2 on t1.id=t2.col group by t2.col;
MC: wait until C3 ready;
C2: rollback;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C3: select min(t1.id),max(t1.col) from t t1 left outer join (select min(t.col) as col from t where id>5) as t2 on t1.id=t2.col group by t2.col;
C3: commit work;
C3: select min(t1.id),max(t1.col) from t t1 left outer join (select min(t.col) as col from t where id>5) as t2 on t1.id=t2.col group by t2.col;
C3: commit;
MC: wait until C3 ready;
C3: quit;
C2: quit;
C1: quit;

