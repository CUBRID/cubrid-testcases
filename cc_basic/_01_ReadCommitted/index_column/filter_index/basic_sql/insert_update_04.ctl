/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
insert and update changed a lot of filter index value, check select result
update value in filter index to values which also satisfy filter condition

NUM_CLIENTS = 2
C2 select
C1 insert a value which satisfy filter condition
C1 update the above value to which don't satisfy filter condition
C1 select using filter index
C2 select
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: create index idx on t(id) where id%2=0;
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr) from db_class a,db_class b,db_class c,db_class d limit 10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* should not see C1 change */
C2: select sum(id),sum(col) from t where id%2=0 and (select sleep(5)) = 0 using index idx(+);
MC: wait until C2 ready;
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr) from db_class a,db_class b,db_class c,db_class d limit 10000;
C1: update t set id=id*2 where id > 0;  
C1: select sum(id),sum(col) from t where id%2=0 using index idx(+);
C1: commit;
MC: wait until C1 ready;
/* should see C1 commit */
C2: select sum(id),sum(col) from t where id%2=0 using index idx(+);
C2: commit;

C2: quit;
C1: quit;
