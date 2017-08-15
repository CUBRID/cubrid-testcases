/*
Test Case: select & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1, C2 select on overlapped multi rows.

NUM_CLIENTS = 2
C1: select on table t1
C2: select on table t1
*/
 

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int primary key, age int, name varchar(10));
C1: insert into t1 values (1,5,'abc'), (2,3,'def'),(3,10,'gh'),(4,12,'ijk'),(5,15,'ab'),(6,7,'dd');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id>2 order by 1,2,3;
MC: wait until C1 ready;
C2: select * from t1 where age<15 order by 1,2,3;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
