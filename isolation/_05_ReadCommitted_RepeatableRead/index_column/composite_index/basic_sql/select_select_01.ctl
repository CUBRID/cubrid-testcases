/* 
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1, C2, C3 select on multi rows. 
NUM_CLIENTS = 3
C1: select on table t1
C2: select on table t1
C3: select on table t1
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C2: commit;
C3: commit;
/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int, age int, name varchar(10));
C1: insert into t1 values (5,5,'abc');insert into t1 values (5,3,'def');insert into t1 values(5,5,'gh');insert into t1 values(5,12,'ijk');insert into t1 values(5,15,'ab');insert into t1 values(6,7,'gg');
C1: create index idx on t1(id, age, name);
C1: commit;

/* test case */
C1: select * from t1 where id>3 order by 1,2,3;
C1: insert into t1 values(5,13,'fan');
MC: wait until C1 ready;
C2: select * from t1 where age>10 order by 1,2,3;
C2: select * from t1 where id= 5 and age between 5 and 13 order by 1,2;
MC: wait until C2 ready;
C3: select * from t1 where name like 'g%' order by 1,2,3;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
C1: select * from t1 where id>3 order by 1,2,3;
C1: commit;

C1: quit;
C2: quit;
C3: quit;
