/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_01.ctl
Author: Lily
Test Point:
-    Insert: no row locks acquired if no unique indexes 
-    Update: X_LOCK acquired on current instance 
one user insert, another update the same row

NUM_CLIENTS = 2
C1: insert into t values(1,'abc');
C2: update t set id=2 where id=1; --expected can not see id=1 row
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
C2: update t set id=2 where id=1;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: update t set id=2 where id=1;
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

