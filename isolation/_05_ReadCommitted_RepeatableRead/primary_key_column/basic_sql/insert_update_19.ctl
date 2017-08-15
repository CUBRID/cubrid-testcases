/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
insert into ... select ... from ...

NUM_CLIENTS = 2
C1: insert into t values(2,'abc');
C1: update t set id=8 where id=3;
C2: insert into t2 select * from t order by 1; -- 2 will not insert into t2, insert 3 instead of 8
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
C1: update t set id=8 where id=3;
C1: commit;
MC: wait until C1 ready;
C2: insert into t select id+10,col from t where id<=3;
MC: wait until C2 ready;

/* expected id: 1,3,7,2,11,13,17 */
C1: select * from t order by 1;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

