/*
Test Case: select & select
Priority: 1
Reference case: 
Author: Lily

Test Point:

NUM_CLIENTS = 2
C1: select * from t order by 1,2;
C2: select * from t where length(col)>1 order by 1;
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(1,'abc'),(3,'a bc'),(7,'ta a'),(2,' A '),(4, 'a a a'),(5,'pass A');
C1: create index idx on t(length(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t where length(col)<5 order by 1; 
MC: wait until C1 ready;
C2: select * from t where length(col)>=3 order by 1;
MC: wait until C2 ready;
C1: select * from t where length(col) between 3 and 7 order by 1; 
MC: wait until C1 ready;
C1: commit;
C2: commit;

C2: quit;
C1: quit;

