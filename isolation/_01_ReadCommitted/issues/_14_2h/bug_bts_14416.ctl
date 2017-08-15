/*
Test Case:  select & delete 
Priority: 1
Reference case:
Author: Tonny

Test Point:
C1 select , C2 delete.
Check C1 and C2 will run ok.

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1 (id1 int);
C1: create index idx on t1(id1);
C1: insert into t1 values (1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 order by 1;
MC: wait until C1 ready;
C2: delete from t1;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C2: select * from t1 order by 1;
MC: wait until C2 ready;

C2: quit;
C1: quit;
