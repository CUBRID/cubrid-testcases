/*
Test Case: related to CUBRIDSUS-5084
Priority: 1
Reference case: http://bts4.nhncorp.com/nhnbts/browse/CUBRIDSUS-5084
Author: Lily

Issue title:
Deadlock occurs for INSERT and DELETE multiple values
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C1: drop table if exists t1;
C1: create table t1(a int);
C1: create unique index idx_a on t1 (a);
C1: insert into t1 values (1),(4),(7);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values (2),(5),(8);
MC: wait until C1 ready;
C2: insert into t1 values (3),(6),(9);
C2: delete from t1 where a=1 or a=4 or a=7;
MC: wait until C2 ready;
C1: delete from t1 where a=2 or a=5 or a=8;
MC: wait until C1 ready;
C1: select * from t1 order by 1;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
C2: commit;
MC: wait until C2 ready;

C1: set transaction isolation level repeatable read;
C1: drop table if exists t1;
C1: create table t1(a int);
C1: create unique index idx_a on t1 (a);
C1: insert into t1 values (1),(4),(7);
C1: commit;
MC: wait until C1 ready;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* test case */
C1: insert into t1 values (2),(5),(8);
MC: wait until C1 ready;
C2: insert into t1 values (3),(6),(9);
C2: delete from t1 where a=1 or a=4 or a=7;
MC: wait until C2 ready;
C1: delete from t1 where a=2 or a=5 or a=8;
MC: wait until C1 ready;
C1: select * from t1 order by 1;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

