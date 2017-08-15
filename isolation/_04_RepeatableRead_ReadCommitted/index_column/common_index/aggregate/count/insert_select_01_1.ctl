/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/aggregate/insert_select_01.ctl
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
changes committed after the query started are never seen
there are many unvacuum version, test select count(id) correctness
combination

NUM_CLIENTS = 6
*/

MC: setup NUM_CLIENTS = 6;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

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
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id);
C1: create index idx_col on t(col);
C1: insert into t select rownum,rownum%10 from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
C1: commit;
MC: wait until C1 ready;

/* test case */
/* 
  prepare unvacuumed version
*/
C1: update t set id=id-1 where mod(id,5)=0;
MC: wait until C1 ready;
C2: update t set id=id-1 where mod(id,5)=1;
MC: wait until C2 ready;
C3: update t set id=id-1 where mod(id,5)=2;
MC: wait until C3 ready;
C4: update t set id=id-1 where mod(id,5)=3;
MC: wait until C4 ready;
C5: update t set id=id-1 where mod(id,5)=4;
MC: wait until C5 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;
C5: commit;
MC: wait until C5 ready;

C1: update t set id=id-1 where mod(id,5)=0;
MC: wait until C1 ready;
C2: update t set id=id-1 where mod(id,5)=1;
MC: wait until C2 ready;
C3: update t set id=id-1 where mod(id,5)=2;
MC: wait until C3 ready;
C4: update t set id=id-1 where mod(id,5)=3;
MC: wait until C4 ready;
C5: update t set id=id-1 where mod(id,5)=4;
MC: wait until C5 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;
C5: commit;
MC: wait until C5 ready;

C1: update t set id=id-1 where mod(id,5)=0;
MC: wait until C1 ready;
C2: update t set id=id-1 where mod(id,5)=1;
MC: wait until C2 ready;
C3: update t set id=id-1 where mod(id,5)=2;
MC: wait until C3 ready;
C4: update t set id=id-1 where mod(id,5)=3;
MC: wait until C4 ready;
C5: update t set id=id-1 where mod(id,5)=4;
MC: wait until C5 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;
C5: commit;
MC: wait until C5 ready;
C1: delete from t where mod(id,10)=0;
C1: commit;
MC: wait until C1 ready;

/*
  start test
*/
C1: insert into t select * from t where id between 3 and 5;
MC: wait until C1 ready;
C5: insert into t select * from t where id between 2 and 4;
MC: wait until C5 ready;
C1: commit;
MC: wait until C1 ready;
C2: insert into t values(1,'aa');
MC: wait until C2 ready;
C4: insert into t select * from t where id between 4 and 5;
MC: wait until C4 ready;
C6: select col,count(id) from t where id between 1 and 9000 group by col order by col;
MC: wait until C6 ready;
C2: commit;
MC: wait until C2 ready;
C4: commit;
MC: wait until C4 ready;
C5: commit;
MC: wait until C5 ready;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
C5: quit;
C6: quit;
