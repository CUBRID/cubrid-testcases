/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user update 1 to 6, another insert value 1

NUM_CLIENTS = 2
C1: update t set id=6 where id=1;
C2: insert into t values(1,'abc'); -- expected blocked
C1: rollback
C2: commit -- expected ok
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=6 where id=1;
MC: wait until C1 ready;
C2: insert into t values(1,'abc');
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

