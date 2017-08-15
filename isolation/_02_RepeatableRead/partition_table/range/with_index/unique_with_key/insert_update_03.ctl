/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user insert P1(1,abc), update p1(1,abc) to p2(11,abc), another insert p2(11,abc)

NUM_CLIENTS = 3
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
C1: update t set id=11 where id=1;
C1: update t set id=1 where id=11;
MC: wait until C1 ready;

C2: insert into t values(11,'abc');
MC: wait until C2 blocked;

C3: insert into t values(1,'abc');
MC: wait until C3 blocked;

C1: commit;
MC: wait until C2 ready;
/* expect insert ok */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

MC: wait until C3 ready;
/* expect insert fail */
/* expect no value */
C3: select * from t order by 1,2;
C3: commit;
MC: wait until C3 ready;

/* expected (1,abc)(11,'abc') */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
C3: quit;
