/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/insert_select_01.ctl
Author: Lily

Test Point:
simple count, there are unvacuumed data, and uncommitted update and insert at the same time
C1 update begin
               C2 insert begin
                              C3 select  begin
               C2 commit
C1 commit
                               C3 select  begin

NUM_CLIENTS = 3
C3: select count(id) from t; 
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
C1: create table t(id int,col varchar(10));
C1: insert into t select rownum,rownum%100 from db_class a,db_class b,db_class c limit 1000;
C1: update t set id=id-1,col=col+id;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set id=col-1 where id%2=0;
MC: wait until C1 ready;

C2: insert into t select t.* from t where id%3=0;
MC: wait until C2 ready;

C3: select count(t.id) from t order by col;
MC: wait until C3 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C3: select count(id) from t order by col;
C3: commit work;
C3: select count(id) from t order by col;
C3: commit;
MC: wait until C3 ready;

C3: quit;
C2: quit;
C1: quit;

