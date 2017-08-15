/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/insert_select_01.ctl
Author: Lily

Test Point:
there is expr and subquery in avg, there are unvacuumed data, and uncommitted update and insert at the same time
C1 update begin
               C2 insert begin
                              C3 select begin
               C2 commit
C1 commit
                                  C3 select begin
NUM_CLIENTS = 3
C3: select id=(select avg(id) from t) from t;
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
C1: insert into t select rownum,rownum%10 from db_class a,db_class b,db_class c limit 1000;
C1: update t set col=col-1;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set id=col-1 where id%2=0 and (select sleep(10)=0);
MC: sleep 1;
C2: insert into t select t.* from (select sleep(5))x, t where id%3=0;
MC: sleep 1;
C3: select avg(id) from t group by col;
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;

C1: rollback;
MC: wait until C1 ready;
C3: select avg(id) from t group by col;
C3: commit work;

C3: select avg(id) from t group by col;
MC: wait until C3 ready;

C3: commit;
C3: quit;
C2: quit;
C1: quit;

