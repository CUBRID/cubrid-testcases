/*
Test Case: related to CUBRIDSUS-5011
Priority: 1
Reference case: http://bts4.nhncorp.com/nhnbts/browse/CUBRIDSUS-5011
Author: Lily

Issue title:
Deadlock occurs for INSER ON DUPLICATE KEY UPDATE operations
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
C1: insert into t1 values (7) on duplicate key update a=6;
MC: wait until C1 ready;
C2: insert into t1 values (2);
C2: insert into t1 values (4) on duplicate key update a=3;
MC: wait until C2 ready;
C1: delete from t1 where a=1;
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
C1: insert into t1 values (7) on duplicate key update a=6;
MC: wait until C1 ready;
C2: insert into t1 values (2);
C2: insert into t1 values (4) on duplicate key update a=3;
MC: wait until C2 ready;
C1: delete from t1 where a=1;
MC: wait until C1 ready;
C1: select * from t1 order by 1;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

