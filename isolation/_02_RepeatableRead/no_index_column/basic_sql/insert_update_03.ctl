/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_03.ctl
Author: Lily
Test Point:
one user insert 6, another update value to 6

NUM_CLIENTS = 2
C1: insert(6);
C2: update t set id=6 where id=5; --expected ok
C1: commit
C2: commit
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(6,'abc');
MC: wait until C1 ready;
C2: update t set id=6 where id=5;
C1: commit work;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

