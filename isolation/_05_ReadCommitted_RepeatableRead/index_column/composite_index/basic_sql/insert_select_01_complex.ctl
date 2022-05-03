/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data or changes committed after the query started are never seen
there are a lot of unvacuumed version, index skip scan

combination
 a) some user committed before the query begin
 b) some begin before the select begin, but commit after the select begin
 c) some begin before the select begin, commit after the select end
 d) some begin after the select begin, commit before the select end
 e) some begin after the select begin, commit after the select end

NUM_CLIENTS = 6
*/

MC: setup NUM_CLIENTS = 6;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;

C5: set transaction lock timeout INFINITE;
C5: set transaction isolation level repeatable read;

C6: set transaction lock timeout INFINITE;
C6: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: insert into t select rownum,rownum%100 from db_class a,db_class b,db_class c,db_class d where rownum <= 1000;
C1: create index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* prepare unvacuumed version */
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
C2: commit;
C3: commit;
C4: commit;
C5: commit;

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
C2: commit;
C3: commit;
C4: commit;
C5: commit;

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
C2: commit;
C3: commit;
C4: commit;
C5: commit;
C1: delete from t where mod(id,10)=0;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;
MC: wait until C4 ready;
MC: wait until C5 ready;

/*
  stage1 | select begin |stage2 | select end| stage3
  C1: 1,1|C2: 1,2|C3:2,2|C4: 2,3|C5, 1,3
*/
/* expect insert 300 rows */
C1: insert into t select * from t where col between 3 and 5;
MC: wait until C1 ready;
/* expect insert 3 rows */
C5: insert into t select * from t where id between 2 and 4;
MC: sleep 5;
MC: wait until C1 ready;
MC: wait until C2 ready;
/* expect 100000+300 */
C1: select count(*) from t;
C1: commit;
C2: insert into t values(1,1);

/* expected 100 */
C6: select count(*) from t where col=1;
MC: wait until C6 ready;
C3: insert into t values(2,1);
MC: wait until C3 ready;
C2: commit;
C3: commit;
/* expect insert 2 rows */
C4: insert into t select * from t where id=1;
MC: wait until C6 ready;
C4: commit;
C5: commit;
MC: wait until C4 ready;
MC: wait until C5 ready;

C6: commit;
C2: quit;
C1: quit;

