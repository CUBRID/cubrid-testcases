/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user insert and then delete in-place, another user insert the same row

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int, col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t select 1,'a' from db_class a,db_class b,db_class c where rownum<=10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select * from t;
MC: wait until C1 ready;

C2: insert into t select * from t;
MC: wait until C2 ready;

C1: delete from t where id=1;
/*MC: wait until C1 ready;
MC: wait until C2 ready;*/
C1: commit work;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;
C2: select count(*) from t order by 1;
C2: select distinct * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;

