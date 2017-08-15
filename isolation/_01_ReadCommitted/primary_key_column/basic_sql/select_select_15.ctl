/*
Test Case: select & select
Priority: 1
Reference case:
Author: Mandy

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
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1 (id int, name varchar(10), primary key(id, name));
C1: insert into t1 values (1,'abc'), (2,'def'),(3,'gh'),(1,'ab'),(1,'def'),(2,'abc');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id>1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where name='abc' order by 1,2;
MC: wait until C2 ready;
C3: select * from t1 where id=2 and name='abc' order by 1,2;
MC: wait until C3 ready;
C1: commit;
C2: commit;
C3: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
