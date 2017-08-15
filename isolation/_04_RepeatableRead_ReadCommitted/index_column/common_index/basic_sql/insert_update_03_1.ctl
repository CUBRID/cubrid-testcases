/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_03.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user insert 6, another update value to 6
unique index

NUM_CLIENTS = 2
C1: insert into t values(6,'def');
C2: update t set id=6 where id=5; --expected blocked
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
C1: create table t(id int unique,col varchar(10));
C1: insert into t values(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(6,'def');
MC: wait until C1 ready;
C2: update t set id=6 where id=5;
MC: wait until C2 blocked;
C1: commit work;
C2: commit;
/* expected (5,abc)(6,def)*/
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

