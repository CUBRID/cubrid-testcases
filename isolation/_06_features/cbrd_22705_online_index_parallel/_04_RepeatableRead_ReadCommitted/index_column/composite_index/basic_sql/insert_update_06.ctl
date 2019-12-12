/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
there are overlap on the second key column

NUM_CLIENTS = 2
prepare(7,a)(8,bc)
C1: insert into t values(8,'abc');
C2: update t set col='abc' where id>0;
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
C1: insert into t values(7,'a');
C1: insert into t values(8,'bc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: update t set col='abc' where id>0;
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit;

/* expected (7,a)(8,bc)(8,abc) */
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;
