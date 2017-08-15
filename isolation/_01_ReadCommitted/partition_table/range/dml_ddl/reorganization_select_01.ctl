/*
Test Case: reorganize partition & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user reorganize partition, another select values

NUM_CLIENTS = 2
C1: alter table t reorganize partition p1 into(partition p1_1 values less than (200),partition p1_2 values less than (1000));
C2: select count(t1.id) from t t1,t t2 group by t1.col;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (1000),partition p2 values less than (100001));
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%20 from db_class a,db_class b,db_class c,db_class d limit 100000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t reorganize partition p1 into(partition p1_1 values less than (200),partition p1_2 values less than (1000)); 
MC: sleep 1;
MC: wait until C1 ready;

C2: select col,count(id) from t group by col order by 1,2;
MC: wait until C2 blocked;

C1: commit work;
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;

/* expected (1000000) */
C2: select count(*) from t;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

