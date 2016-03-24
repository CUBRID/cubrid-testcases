/*
Test Case: remove partition & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user remove partition, another select values
remove partition rollback

NUM_CLIENTS = 2
C1: select count(t1.id) from t t1,t t2 group by t1.col;
C2: alter table t remove partitioning;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (100),partition p2 values less than (201));
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=200;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t remove partitioning;
MC: sleep 1;
/* expected (40000) */
C2: select count(t1.id) from t t1,t t2 group by t1.col;
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;
/* expected (200) */
C2: select count(*) from t;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

