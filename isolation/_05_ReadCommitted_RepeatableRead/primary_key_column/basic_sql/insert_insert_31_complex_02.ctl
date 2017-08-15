/*
Test Case: select & update
Priority: 1
Reference case:
Author: Bobo

Test Point:
Alter table

NUM_CLIENTS = 3
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t_sub1;
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: create table t_sub1(seq int primary key, id int, val int(10), constraint fk_id foreign key (id) REFERENCES t (id) ON DELETE CASCADE ON update RESTRICT );
C1: insert into t values(1,'a');
C1: insert into t values(10,'a10');
C1: insert into t_sub1 values(1, 1, 111);
C1: insert into t_sub1 values(2, 10, 1000);
C1: insert into t_sub1 values(3, 10, 3000);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: ALTER table t_sub1 drop foreign key fk_id;
C1: commit;
MC: wait until C1 ready;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;
C3: update t_sub1 set id=2 where id=10;
MC: wait until C3 ready;
C2: select * from t_sub1 order by 1;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C2: select * from t_sub1 order by 1;
C2: commit;
MC: wait until C2 ready;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;


C3: quit;
C2: quit;
C1: quit;

