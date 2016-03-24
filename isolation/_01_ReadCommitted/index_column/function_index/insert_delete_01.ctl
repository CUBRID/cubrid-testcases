/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_01.ctl
Author: Rong Xu

Test Point:
one user insert and then delete in-place, another user insert the same value

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(1,'a'); --expected ready
C1: delete from t where trim(col)='a'; --expected don't delete C2's insert
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;

C2: insert into t values(1,'a');
/*MC: wait until C2 blocked;*/
MC: wait until C2 ready;

C1: delete from t where trim(col)='a';
C1: commit work;
MC: wait until C1 ready;
/*MC: wait until C2 ready;*/

C2: commit;
/* expected (1,'a') */
C2: select * from t where trim(col)='a';
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;

