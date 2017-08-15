/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Lily

Test Point:
simple sum, there are unvacuumed data, and uncommitted update and insert at the same time
C1 update begin
               C2 insert begin
                              C3 select sum() begin
               C2 commit
C1 commit
                               C3 select sum() begin

NUM_CLIENTS = 3
C3: select sum(id) from t; --expected value is 4999950000
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
C1: insert into t select rownum,rownum%100 from db_class a,db_class b,db_class c,db_class d limit 10000;
C1: commit;
C1: update t set id=id-1,col=col+id;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set id=col-1 where id%2=0;
MC: wait until C1 ready;

C2: insert into t select t1.* from (select t.* from t order by id) t1, (select sleep(5)) x where id%3=0;
MC: sleep 2;
C3: select sum(t.id) from t, (select sleep(10)) x;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C3: select sum(id) from t;
C3: commit work;
MC: wait until C3 ready;

C3: select sum(id) from t;
C3: commit;
MC: wait until C3 ready;

C3: quit;
C2: quit;
C1: quit;

