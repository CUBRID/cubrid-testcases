/*
Test Case: related to CUBRIDSUS-5004
Priority: 1
Reference case: http://bts4.nhncorp.com/nhnbts/browse/CUBRIDSUS-5004
Author: Lily

Issue title:
Deadlock occurs for INSERT and UPDATE
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C1: drop table if exists t1;
C1: create table t1 (id int primary key); 
C1: insert into t1 values (1),(3),(5),(10);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values (4);
MC: wait until C1 ready;
C2: delete from t1 where id=10;
MC: wait until C2 ready;
C1: delete from t1 where id=5;
MC: wait until C1 ready;
C2: delete from t1 where id=3;
MC: wait until C2 ready;
C1: select * from t1 order by 1;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
C2: commit;
MC: wait until C2 ready;

C1: set transaction isolation level repeatable read;
C1: drop table if exists t1;
C1: create table t1 (id int primary key);
C1: insert into t1 values (1),(3),(5),(10);
C1: commit;
MC: wait until C1 ready;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* test case */
C1: insert into t1 values (4);
MC: wait until C1 ready;
C2: delete from t1 where id=10;
MC: wait until C2 ready;
C1: delete from t1 where id=5;
MC: wait until C1 ready;
C2: delete from t1 where id=3;
MC: wait until C2 ready;
C1: select * from t1 order by 1;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

