/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user insert 6, another update value to 6
c1 rollback, re-evaluate

NUM_CLIENTS = 2
C1: insert into t values(6,'def');
MC: wait until C1 ready;
C2: update t set id=6 and col='def' where id=5; --expected c2 blocked, failed
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
C1: insert into t values(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(6,'def');
MC: wait until C1 ready;
C2: update t set id=6,col='def' where id=5;
MC: wait until C2 blocked;
C1: rollback;
/* expected c2 ok */
C2: commit;
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

