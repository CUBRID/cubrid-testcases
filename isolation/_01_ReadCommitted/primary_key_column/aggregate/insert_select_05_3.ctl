/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/index_column/common_index/aggregate/insert_select_01.ctl
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
changes committed after the query started are never seen
there are many unvacuum version, test select min(id) correctness
combination
 a) some user committed before the query begin
 b) some begin before the select begin, but commit after the select begin
 c) some begin before the select begin, commit after the select end
 d) some begin after the select begin, commit before the select end
 e) some begin after the select begin, commit after the select end

NUM_CLIENTS = 6
prepare(1,3,7)
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
C1: create table t(id bigint primary key,col varchar(10));
C1: create unique index idx on t(id);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%10 from db_class a,db_class b,db_class c limit 10000;
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

/*
  stage1 | select begin |stage2 | select end| stage3
  C1: 1,1|C2: 1,2|C3:2,2|C4: 2,3|C5, 1,3
*/
C1: insert into t select id-6,col from t where id between 3 and 5;
MC: wait until C1 ready;
C5: insert into t select id-9,col from t where id between 2 and 4 and sleep(1)=0;
C1: commit;
C2: insert into t values(1,'aa');
MC: wait until C2 ready;

/* expected 10 group */
C6: select col, min(id) from t,(select sleep(5)) x where id between 1 and 9000 group by col order by col;
C3: insert into t values(2,'cc');
MC: wait until C3 ready;
C2: commit;
C3: commit;
C4: insert into t select id-12,col from t where id between 4 and 5 and sleep(1)=0;
MC: wait until C6 ready;
C4: commit;
C5: commit;
MC: wait until C4 ready;
MC: wait until C5 ready;
C6: commit;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
C5: quit;
C6: quit;
