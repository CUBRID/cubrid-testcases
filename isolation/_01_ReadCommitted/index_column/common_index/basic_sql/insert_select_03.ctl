/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
there are a lot of unvacuum version, insert many rows,
test select sum

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%100 from db_class a,db_class b limit 1500;
C1: create index idx_id on t(col);
C1: create index idx_col on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select * from t;
MC: wait until C1 ready;

C2: update t set id=id+1 where id%3=0;
MC: wait until C2 ready;

C3: update t set id=id+2 where id%3=1;
MC: wait until C3 ready;

C4: update t set id=id+3 where id%3=2;
MC: wait until C4 ready;

C1: select sum(col) from t;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;

C2: update t set id=id+1 where id%3=0;
MC: wait until C2 ready;

C3: update t set id=id+2 where id%3=1;
MC: wait until C3 ready;

C4: update t set id=id+3 where id%3=2;
MC: wait until C4 ready;

C2: commit;
MC: wait until C2 ready;

C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;

C1: select sum(col) from t;
MC: wait until C1 ready;

C1: select sum(col) from t;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;
C3: quit;
C4: quit;
