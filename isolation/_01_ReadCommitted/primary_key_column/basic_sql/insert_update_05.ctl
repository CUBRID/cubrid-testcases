/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user insert, another update the same row

NUM_CLIENTS = 2
C1: insert into t values(1,'abc');
C1: update t set id=2 where id=1; --expecte failed,will not see id=1
C1: rollback
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
C2: update t set id=2 where id=1;
C1: rollback work;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

