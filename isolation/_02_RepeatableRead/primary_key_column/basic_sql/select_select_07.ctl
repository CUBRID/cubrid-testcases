/* 
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1, C2 select on multi rows. 

NUM_CLIENTS = 2
C1: select on table t1
C2: select on table t1
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int primary key, age int, name varchar(10));
C1: insert into t1 values (1,5,'abc');insert into t1 values (2,3,'def');insert into t1 values(3,10,'gh');insert into t1 values(4,12,'ijk');insert into t1 values(5,15,'ab');
C1: commit;
MC: wait until C1 ready;

/* test case */
/* select on multi rows without onverlap. */
C1: select * from t1 where id<3 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where id>2 order by 1,2,3;
MC: wait until C2 ready;

C1: select * from t1 where id<4 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where age>10 order by 1,2,3;
MC: wait until C2 ready;

/* select on overlapped multi rows. */
C1: select * from t1 where id>2 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where id<5 order by 1,2,3;
MC: wait until C2 ready;
C1: commit;
C2: commit;

C1: select * from t1 where id>2 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where age<15 order by 1,2,3;
MC: wait until C2 ready;
C1: rollback;
C2: commit;

C1: quit;
C2: quit;
