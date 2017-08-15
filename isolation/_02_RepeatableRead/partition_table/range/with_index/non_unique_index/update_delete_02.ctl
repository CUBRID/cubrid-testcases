/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
heavy insert, update to another partition several times

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int) partition by range(id)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: create index idx on t(id);
C1: insert into t select rownum,rownum*2 from db_class a,db_class b,db_class c where rownum<=10000;
C1: update t set id=id+10000 where id<10000;
C1: update t set id=id-10000 where id>10000;
C1: update t set id=id+10000 where id<10000;
C1: update t set id=id-10000 where id>10000;
C1: insert into t values(10011,10011);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t where id>10000 order by 1,2;
MC: wait until C2 ready;
C1: update t set id=id+10000 where id between 20 and 30; 
C1: update t set id=id-10000 where id between 10020 and 10030;
C1: update t set id=id+10000 where id between 20 and 30; 
C1: commit;
MC: wait until C1 ready;

/* expect 1 row */
C2: select * from t where id>10000 order by 1,2;
/* expect delete 1 row */
C2: delete from t where id between 10010 and 10050;
MC: wait until C2 ready;

/* expect 10000*/
C1: select count(*) from t;
C1: commit work;
MC: wait until C1 ready;
/* expect 0*/
C2: select count(*) from t;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit work;
MC: wait until C2 ready;
C2: select count(*) from t;
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;

