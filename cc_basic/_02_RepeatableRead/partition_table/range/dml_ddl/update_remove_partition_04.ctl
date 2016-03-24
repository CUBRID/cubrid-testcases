/*
Test Case: remove partition & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
when there are lots of old version,one user remove partition, check another select

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (501),partition p2 values less than (1010));
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=1000;
C1: commit work;
C1: delete from t;
C1: commit work;
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=1000;
C1: commit work;
C1: select count(*) from t;
C1: commit work;
MC: wait until C1 ready;

/* prepare old version */
C1: update t set id=id+500 where id<501;
MC: wait until C1 ready;
C2: update t set id=id-500 where id>500;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: update t set id=id+500 where id<501;
MC: wait until C1 ready;
C2: update t set id=id-500 where id>500;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: update t set col='b' where id<501;
MC: wait until C1 ready;
C2: update t set col='b' where id>500;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: update t set col='c' where id>500;
MC: wait until C1 ready;
C2: update t set col='c' where id<500;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: select count(*) from t;
MC: wait until C1 ready;

/* test case */
C1: alter table t remove partitioning;
C1: commit work;
MC: wait until C1 ready;

/* expected (1,b)(999,c) */
C2: select count(*),col from t group by col;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
