/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
savepoint test

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create unique index idx on t(id,col);
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=11 where id=1;
C1: savepoint sp1;
C1: update t set id=12 where id=11;
MC: wait until C1 ready;
C2: insert into t values(11,'abc');
MC: wait until C2 blocked;

/* expect (12,'abc') */
C1: select * from t order by 1,2;
C1: rollback work to sp1;

C1: commit;
MC: wait until C2 ready;
C2: select * from t order by 1;
C2: commit;

C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

/* common table */
C1: drop table if exists t1;
C1: create table t1(id int,col varchar(10));
C1: create unique index idx on t1(id,col);
C1: insert into t1 values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=11 where id=1;
C1: savepoint sp2;
C1: update t1 set id=12 where id=11;
MC: wait until C1 ready;
C2: insert into t1 values(11,'abc');
MC: wait until C2 blocked;

/* expect (12,'abc') */
C1: select * from t1;
C1: rollback work to sp2;

C1: commit;
MC: wait until C2 ready;
C2: select * from t1 order by 1;
C2: commit;

C2: select * from t1 order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

