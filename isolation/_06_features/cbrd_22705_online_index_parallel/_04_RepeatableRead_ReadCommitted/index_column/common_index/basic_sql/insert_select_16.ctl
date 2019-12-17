/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
changes committed after the query started are never seen
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
C1: create index idx on t(id) with online parallel 3;
C1: insert into t values(1,'aa');
C1: insert into t values(3,'bb');
C1: insert into t values(7,'cc');
C1: commit;
MC: wait until C1 ready;

/* test case */
/* 
  stage1 | select begin |stage2 | select end| stage3
  C1: 1,1|C2: 1,2|C3:2,2|C4: 2,3|C5, 1,3
*/
C1: insert into t select * from t;
C5: insert into t select t.* from t where id>0 and (select sleep(5)) = 0;
MC: wait until C5 ready;
C1: commit;
C2: insert into t values(8,'aa');
MC: wait until C2 ready;
C6: select t.* from t where id>0 and (select sleep(1)) = 0 order by id;
MC: wait until C6 ready;
C3: insert into t values(8,'cc');
C2: commit;
C3: commit;
C4: insert into t select t.* from t where id>0 and (select sleep(2)) = 0;
C6: commit;
MC: wait until C6 ready;
C4: commit;
C5: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;
MC: wait until C5 ready;

/* 1,3,7,(8,aa)(8,cc) 1,3,7,(8,aa)(8,cc) 1,3,7,(8,aa)(8,cc)*/
C1: select * from t order by 1,2;
C1: commit;

C6: quit;
C5: quit;
C4: quit;
C3: quit;
C2: quit;
C1: quit;

