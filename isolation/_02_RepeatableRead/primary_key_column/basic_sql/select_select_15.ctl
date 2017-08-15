/*
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1, C2, C3 select on overlapped multi rows.
In this case, the primary key is created on two columns

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
C2: commit;
C3: commit;
/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int, name varchar(10), primary key(id, name));
C1: insert into t1 values (1,'abc');insert into t1 values (2,'def');insert into t1 values(3,'gh');insert into t1 values(1,'ab');insert into t1 values(1,'def');insert into t1 values(2,'abc');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id>1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where name='abc' order by 1,2;
MC: wait until C2 ready;
C3: select * from t1 where id=2 and name='abc' order by 1,2;
C3: commit;
MC: wait until C3 ready;
C1: commit;
C2: commit;

C1: quit;
C2: quit;
C3: quit;
