/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Bobo

Test Point:
C1: delete from t
C2: select t_sub1
C1: commit;
C2: select t_sub1 --expected the data in t_sub1 was deleted

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
C1: create table t_sub1(id int primary key, val int(10), constraint fk_id foreign key (id) REFERENCES t (id) ON DELETE CASCADE ON UPDATE RESTRICT);
C1: insert into t values(1,'a');
C1: insert into t values(10,'a');
C1: insert into t_sub1 values(1, 111);
C1: insert into t_sub1 values(10, 222);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t_sub1 order by 1;
MC: wait until C2 ready;
C1: delete from t where id=1;
MC: wait until C1 ready;
/* expected 1,6,10 */
C2: select * from t_sub1 order by 1;
C2: commit work;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected 1,6,10,5 */
C2: select * from t order by 1;
C2: select * from t_sub1 order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
