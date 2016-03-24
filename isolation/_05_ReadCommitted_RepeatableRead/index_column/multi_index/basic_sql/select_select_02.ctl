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
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int, age int, name varchar(10));
C1: insert into t1 values (1,5,'abc');insert into t1 values (2,3,'def');insert into t1 values(3,10,'gh');insert into t1 values(4,12,'abc');insert into t1 values(5,15,'ab');insert into t1 values(6,7,'aa');insert into t1 values(4,23,'andy');
C1: create index idx1 on t1(id, name);
C1: create index idx2 on t1(name);
C1: commit;

C1: select * from t1 where id>2 and name like 'ab%' order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where name like 'a%' order by 1,2,3;
MC: wait until C2 ready;
C1: rollback;
C2: commit;

C1: quit;
C2: quit;


