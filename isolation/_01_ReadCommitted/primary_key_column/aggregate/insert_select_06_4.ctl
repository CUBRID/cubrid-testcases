/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/aggregate/insert_select_01.ctl
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
changes committed after the query started are never seen
there are many unvacuum version, test select distinct correctness
combination

NUM_CLIENTS = 6
*/

MC: setup NUM_CLIENTS = 6;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

C5: set transaction lock timeout INFINITE;
C5: set transaction isolation level read committed;

C6: set transaction lock timeout INFINITE;
C6: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint,col varchar(10));
C1: create unique index idx_id on t(id);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%10 from db_class a,db_class b,db_class c,db_class d limit 1000;
C1: commit;
MC: wait until C1 ready;

/* test case */
/* 
  prepare unvacuumed version
*/
C1: update t set id=id+1;
C1: commit;

C1: update t set id=id+1;
C1: commit;

C1: update t set id=id+1;
C1: commit;

C1: delete from t where id%10=0;
C1: commit;
MC: wait until C1 ready;

C1: insert into t select id-6,col from t where id between 3 and 5;
MC: wait until C1 ready;
C5: insert into t select id-9,col from t where id between 2 and 4;
MC: wait until C5 ready;
C1: commit;
MC: wait until C1 ready;
C2: insert into t values(1,'aa');
MC: wait until C2 ready;

/* expected 10 group */
C6: select distinct col from t where id between 1 and 1000;
MC: wait until C6 ready;
C3: insert into t values(2,'cc');
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: insert into t select id-12,col from t where id between -9 and 4;
C4: commit;
MC: wait until C4 ready;
C5: commit;
MC: wait until C5 ready;
C6: quit;
C5: quit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;

