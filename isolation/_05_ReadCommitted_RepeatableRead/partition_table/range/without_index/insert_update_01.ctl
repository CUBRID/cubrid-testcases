/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user insert lots of 1 without commit, another update value 1 to 11

NUM_CLIENTS = 2
C1: insert(11);
C2: update t set id=11 where id=1; --expected blocked
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select 1,'abc' from db_class a,db_class b,db_class c where rownum<=10000;
MC: wait until C1 ready;
C2: update t set id=11 where id=1;
MC: wait until C2 ready;
/*MC: wait until C2 ready;*/

/* expect 10001 row */
C1: select count(*) from t where id=1;
C1: commit work;
MC: wait until C1 ready;

/* expect 1 row */
C2: select count(*) from t where id=1;
C2: commit;

/* expected 1,11 */
C2: select distinct(id) from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

