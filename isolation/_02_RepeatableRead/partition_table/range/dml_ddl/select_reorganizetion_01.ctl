/*
Test Case: reorganize partition & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user reorganize partition, another select values

NUM_CLIENTS = 2
C1: select count(t1.id) from t t1,t t2 group by t1.col;
C2: alter table t reorganize partition p1 into(partition p1_1 values less than (200),partition p1_2 values less than (1000));
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (1000),partition p2 values less than (2001));
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=2000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expected (4000000) */
C1: select count(t1.id) from t t1,t t2 group by t1.col;
MC: sleep 1;
C2: alter table t reorganize partition p1 into(partition p1_1 values less than (200),partition p1_2 values less than (1000)); 
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit;
/* expected (2000) */
C2: select count(*) from t;
C2: commit;

C2: quit;
C1: quit;

