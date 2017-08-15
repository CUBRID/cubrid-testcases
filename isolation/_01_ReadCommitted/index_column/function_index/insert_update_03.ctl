/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_03.ctl
Author: Rong Xu
Test Point:
-    Insert: no row locks acquired if no unique indexes
-    Update: X_LOCK acquired on current instance 
one user insert 'a ', another update value to 'a '

NUM_CLIENTS = 2
C1: insert into t values(6,'a ');
C2: update t set col='a ' where trim(col)='b'; --expected ok
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
C1: insert into t values(5,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(6,'a ');
MC: wait until C1 ready;
C2: update t set col='a ' where trim(col)='b';
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

