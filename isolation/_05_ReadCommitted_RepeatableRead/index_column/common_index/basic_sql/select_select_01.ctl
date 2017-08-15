/*
Test Case: select & select
Priority: 1
Reference case:
Author: Lily

Test Point:
C1, C2 select on single row

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
C1: create table t1 (id int, col varchar(10));
C1: insert into t1 values (1,'abc');insert into t1 values (2,'def');insert into t1 values(1,'gh');
C1: create index idx on t1(id);
C1: commit;
MC: wait until C1 ready;

/* select on different single rowi */
C1: select * from t1 where id=1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where id=2 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
/* select on different single row */
C1: select * from t1 where id=1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where col='def' order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

/* select on different single row */
C1: select * from t1 where id=1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where id=1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
/* select on different single row */
C1: select * from t1 where id=1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where col='abc' order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;

C1: quit;
C2: quit;

