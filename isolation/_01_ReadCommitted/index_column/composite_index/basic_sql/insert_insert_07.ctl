/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_23.ctl
Author: Rong Xu

Test Point:
ON DUPLICATE KEY UPDATE ...
insert into t values(1,'b'),(2,'c') on duplicate key update ...
A insert on duplicate ...
B insert rows including A inserted row -- expected waiting

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(1,'a'),(2,'c') on duplicate key update id=2; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;

C2: insert into t values(1,'a'),(2,'c') on duplicate key update id=2;
MC: wait until C2 blocked;

C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;

/* expected (2,a)(2,c) */
C1: select * from t order by 1,2;
MC: wait until C1 ready;

C2: commit;          
MC: wait until C2 ready;

C2: quit;
C1: quit;

