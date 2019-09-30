/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user insert 6, another update value to 6
unique index and non unique index,where using non unique index
unique index should also be locked

NUM_CLIENTS = 2
C1: insert into t values(6,'def');
C2: update t set id=6 where id=5 and col='abc'; --expected blocked
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
C1: create table t(id int,col varchar(10) unique);
C1: create index idx on t(id) with online parallel 3;
C1: insert into t values(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col='def' where id=5 using index idx;
MC: wait until C1 ready;
C2: insert into t values(6,'def');
MC: wait until C2 blocked;
C1: commit work;
C2: commit;

/* expected (5,def) */
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

