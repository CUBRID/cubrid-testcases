/*
Issue Case: CUBRIDSUS-16593
Priority: 1
Reference case:
Isolation Levels: Repeatable Read/Repeatable Read
Author: 

Test Plan:
data visibility is different between CUBRID, Mysql and Postgresql 

Test Scenario:

Test Point:
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;

C1: drop table if exists t;
C1: create table t (a int);
C1: insert into t values(1),(1);
C1: commit;

C1: select * from t;
MC: wait until C1 ready;

C2: delete from t where a>0;
C2: commit;
MC: wait until C2 ready;

C1: select * from t;
C1: create unique index idx on t(a);
C1: insert into t values(1);
C1: select * from t;
C1: drop table t;

C1: quit;
C2: quit;
