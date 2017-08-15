/*
Test Case: select & select
Priority: 2
Reference case:
Author: Lily

Test Point:
C1, C2 select on multi rows.

NUM_CLIENTS = 2
C1: select * from t1; 
C2: select * from t2;
*/
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: insert into t select rownum,rownum%100 from db_class a,db_class b limit 500;
C1: create index idx_id on t(col) where col=1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t where col=1 using index idx_id(+) order by 1,2;
MC: wait until C1 ready;

C2: select * from t where col=1 using index idx_id(+) order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;
