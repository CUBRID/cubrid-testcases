/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
there are overlap on the first key column

NUM_CLIENTS = 2
C1: insert into t values(8,'abc');
C2: update t set id=8,col='d' where id=7; -- expected ready
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id,col) with online parallel 7;
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: update t set id=8,col='d' where id=7;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;
