/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
update many rows and rollback,another insert

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: drop table if exists t1;
C1: create table t(id int,col int primary key) partition by range(col)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: create table t1(id int);
C1: insert into t1 values(1);
C1: insert into t1 values(2);
C1: insert into t1 values(3);
C1: insert into t1 values(4);
C1: insert into t1 values(5);
C1: insert into t1 values(6);
C1: insert into t1 values(7);
C1: insert into t1 values(8);
C1: insert into t1 values(9);
C1: insert into t1 values(10);
C1: insert into t select rownum,rownum*2-1 from t1 a,t1 b,t1 c,t1 d,t1 e,t1 f where rownum <= 10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=id+1,col=col+1;
MC: sleep 1;
C2: insert into t values(1,1);
MC: wait until C2 blocked;
C1: rollback;
C2: commit work;
/* expected 1000001 */
C2: select count(*) from t order by 1;
C2: commit;

C2: quit;
C1: quit;

