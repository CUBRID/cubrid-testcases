/*
Test Case: insert & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_11.ctl
Author: Rong Xu

Test Point:
one user insert and then delete in-place, another delete the whole table

NUM_CLIENTS = 2
C1: insert(4);
C2: delete from t where id>0; --ready
C1: delete from t where id=4; 
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int, col varchar(10));
C1: create index idx on t(id) with online parallel 3;
C1: insert into t values(6,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(4,'abc');
MC: wait until C1 ready;
C2: delete from t where id>0;
MC: wait until C2 ready;
C1: delete from t where id=4;
C1: commit;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

