/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
heavy insert, insert lots of data

NUM_CLIENTS = 2
C1: insert into t select rownum,rownum*2 from db_class a,db_class b,db_class c where rownum <= 10000;
C2: insert into t select rownum,rownum*2-1 from db_class a,db_class b,db_class c where rownum <= 10000; --expected no block
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int, primary key(id,col)) partition by range(id)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum,rownum*2 from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
MC: wait until C1 ready;

C2: insert into t select rownum,rownum*2-1 from db_class a,db_class b,db_class c,db_class d where rownum <= 10000;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;

C2: commit work;
C2: select count(*) from t order by 1;
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;

