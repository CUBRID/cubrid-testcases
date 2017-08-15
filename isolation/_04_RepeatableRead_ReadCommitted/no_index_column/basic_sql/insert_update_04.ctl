/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_04.ctl
Author: Rong Xu
Test Point:
-    Insert: no row locks acquired if no unique indexes 
-    Update: X_LOCK acquired on current instance
one user insert, another update other row

NUM_CLIENTS = 2
C1: insert(8);
C2: update t set id=9 where id=7; --expected update successfully
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: update t set id=9 where id=7;
MC: wait until C2 ready;
C1: commit work;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;
