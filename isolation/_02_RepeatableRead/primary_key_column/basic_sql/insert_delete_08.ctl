/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
one user insert and then delete in-place, another user insert the same row
re-evaluate
the first user rollback

NUM_CLIENTS = 2
C1: insert into t values(2,'abc');
C1: delete from t where id=2;
C2: insert into t values(2,'abc'); --expect blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
C1: delete from t where id=1;
MC: wait until C1 ready;
C2: insert into t values(1,'abc');
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
/* expect (1,abc) */
C2: select * from t order by 1;
C2: commit;

/* expect (1,abc) */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

