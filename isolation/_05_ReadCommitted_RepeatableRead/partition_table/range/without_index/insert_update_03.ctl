/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user insert/update many rows many times

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C1: commit;
MC: wait until C1 ready;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* preparation */
C1: drop table if exists t;
C1: drop table if exists t1;
C1: create table t(id int,col int) partition by range(id)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: create table t1(id int);
C1: insert into t1 values(1);insert into t1 values(2);insert into t1 values(3);insert into t1 values(4);insert into t1 values(5);insert into t1 values(6);insert into t1 values(7);insert into t1 values(8);insert into t1 values(9);insert into t1 values(10);
C1: insert into t select rownum,rownum*2-1 from t1 a,t1 b,t1 c,t1 d,t1 e,t1 f where rownum<=1000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=id+1,col=col+1;
C1: insert into t select * from t;
C1: update t set id=id+1,col=col+1;
C1: insert into t select * from t;
C1: commit;
MC: wait until C1 ready;

/* expected 4000 */
C2: select count(id) from t order by 1,col;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
