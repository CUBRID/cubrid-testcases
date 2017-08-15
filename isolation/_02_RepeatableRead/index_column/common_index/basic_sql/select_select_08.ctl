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
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int, age int, name varchar(10));
C1: insert into t1 values (1,5,'abc');insert into t1 values (2,3,'def');insert into t1 values(3,10,'gh');insert into t1 values(4,12,'ijk');insert into t1 values(5,15,'ab');insert into t1 values(6,7,'dd');
C1: create index idx on t1(id);
C1: commit;
MC: wait until C1 ready;

/* without overlap */
C1: select * from t1 where id<3 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where id>2 and id<5 order by 1,2,3;
MC: wait until C2 ready;
C3: select * from t1 where id>4 order by 1,2,3;
MC: wait until C3 ready;
C1: commit;
C2: rollback;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

/* overlapped */
C1: select * from t1 where id>2 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where age<15 order by 1,2,3;
MC: wait until C2 ready;
C3: select * from t1 where name like 'd%' order by 1,2,3;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
