/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/aggregate/insert_select_01.ctl
Author: Lily

Test Point:
there is expr and subquery in count, there are unvacuumed data, and uncommitted update and insert at the same time

NUM_CLIENTS = 3
C3: select id=(select count(id)>min(id) from t),max(col) from t group by col;
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
C1: insert into t select rownum,rownum%10 from db_class a,db_class b,db_class c,db_class d limit 10;
C1: commit;
C1: update t set col=col-1;
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t set id=col-1 where id%2=0;
MC: wait until C1 ready;

C2: insert into t select * from t where id%3=0;
MC: wait until C2 ready;

C3: select id=(select count(id)>min(id) from t),max(col) from t group by col,id;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C1: rollback;
MC: wait until C1 ready;

C3: select id=(select count(id)>min(id) from t),max(col) from t group by col,id;
C3: commit work;
C3: select id=(select count(id)>min(id) from t),max(col) from t group by col,id;
C3: commit;
MC: wait until C3 ready;

C3: quit;
C2: quit;
C1: quit;

