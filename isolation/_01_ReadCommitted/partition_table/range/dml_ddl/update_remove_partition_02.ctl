/*
Test Case: remove partition & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user update unfinished, another remove partition

NUM_CLIENTS = 2
C1: update t set id=id%5000+2000 where length(col)=10 and col like '%a%' and col in(select t1.col from t t1,t t2 group by t1.col)
C1: alter table t remove partitioning; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (500),partition p2 values less than (1001));
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'a' from db_class a,db_class b,db_class c limit 1000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=id%500+200 where length(col)=10 and col like '%a%' and col in(select t1.col from t t1,t t2 group by t1.col);
MC: wait until C1 ready;
C2: alter table t remove partitioning;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: commit;
/* expected (20000) */
C2: select count(*) from t;
C2: commit;

C2: quit;
C1: quit;

