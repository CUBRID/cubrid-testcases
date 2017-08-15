/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user insert to p1(11,'a'), another update value p1(1,'a') to p2(11,a)

NUM_CLIENTS = 2
C1: insert(11,a);
C2: update t set id=11 where id=1; --expected blocked
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create index idx on t(col);
C1: insert into t values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1,2;
MC: wait until C2 ready;
C1: update t set id=11 where id=1;
C1: commit;
MC: wait until C1 ready;

/* expect ERROR: Serializable conflict due to concurent update */
C2: update t set col='b' where col='a';
/* expect (1,'a') */
C2: select * from t order by 1,2;

MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

