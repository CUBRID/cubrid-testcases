/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Bobo

Test Point:
ALTER table key

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t_sub1;
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: create table t_sub1(id int primary key, val int(10), constraint fk_id foreign key (id) REFERENCES t (id) ON DELETE CASCADE ON update RESTRICT );
C1: insert into t values(1,'a');
C1: insert into t values(10,'a');
C1: insert into t_sub1 values(1, 111);
C1: insert into t_sub1 values(10, 1000);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: ALTER table t_sub1 drop foreign key fk_id;
C1: insert into t_sub1 values(5,222);
C1: select * from t_sub1 order by 1;
C1: select * from t order by 1;
C1: ALTER table t drop primary key;
C1: insert into t values(2,'a2');
C1: select * from t order by 1;
MC: wait until C1 ready;
C2: delete from t where id=1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C1: select * from t_sub1 order by 1;
C1: select * from t order by 1;
C1: commit;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

