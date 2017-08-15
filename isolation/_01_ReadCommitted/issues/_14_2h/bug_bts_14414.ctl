/*
Test Case: delete & delete & insert
Priority: 1
Reference case:
Author: Tonny

Test Point:
C1 delete and insert , C2 delete.
Check C1 should block C2.After C1 commit, C2 will run successful.The only one result will be.The behavior like postgres 9.3.

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
C1: delete from t1;
MC: wait until C1 ready;
C2: delete from t1 where id1=1;
MC: wait until C2 blocked;

C1: insert into t1 values (1);
C1: commit;
C2: commit;

/* expect (1) */
C2: select * from t1 order by 1;

C2: quit;
C1: quit;
