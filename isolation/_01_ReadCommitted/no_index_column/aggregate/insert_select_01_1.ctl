/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/insert_select_01.ctl
Author: Rong Xu

Test Point:
there is expr in sum, there are unvacuumed data, and uncommitted update and insert at the same time
C1 update begin
               C2 insert begin
                              C3 select sum() begin
                              C3 commit
               C2 commit
C1 commit

NUM_CLIENTS = 3
C3: select sum(id)>id-col+8 from t group by col;
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint,col varchar(10));
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%10 from db_class a,db_class b,db_class c,db_class d limit 100000;
C1: commit;
C1: update t set col=col-1;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set id=col-1 where id%2=0;
MC: wait until C1 ready;

C2: insert into t select * from t where id%3=0;
MC: wait until C2 ready;

C3: select sum(id)>id-col+8 from t group by col;
C3: commit work;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;


C3: quit;
C2: quit;
C1: quit;

