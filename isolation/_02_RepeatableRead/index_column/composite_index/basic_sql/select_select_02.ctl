/*
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1, C2 select on overlapped multi rows.

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
C1: create table t1 (id int, name varchar(10));
C1: insert into t1 values (1,'abc');insert into t1 values (2,'def');insert into t1 values(3,'abc');insert into t1 values(4,'ijk');insert into t1 values(5,'abc');insert into t1 values(6,'dd');
C1: create index idx on t1(id, name);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where name='abc' and id>2 order by 1,2;
C1: insert into t1 values(2,'abc'),(4,'abc');
MC: wait until C1 ready;
C2: select * from t1 where name='abc' and id<6 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 where name='abc' and id<6 order by 1,2;
C2: commit;
C2: select * from t1 where name='abc' and id<6 order by 1,2;
C2: commit;
C1: quit;
C2: quit;
