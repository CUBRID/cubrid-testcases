/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
test basic snapshot

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(3,'a ');
C1: insert into t values(7,' a');
C1: create index idx on t(trim(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'a ');
C1: commit;
MC: wait until C1 ready;
C2: insert into t values(4,'a ');
MC: wait until C2 ready;

/* expect 1,3,7 */
C3: select * from t where trim(col)='a' order by 1;
MC: wait until C3 ready;
C2: commit;
MC: wait until C2 ready;
C4: insert into t values(5,'a ');
C4: commit;
MC: wait until C4 ready;

/* expect 1,3,7 */
C3: select * from t where trim(col)='a' order by 1;
C3: commit;
MC: wait until C3 ready;

C4: quit;
C3: quit;
C2: quit;
C1: quit;

