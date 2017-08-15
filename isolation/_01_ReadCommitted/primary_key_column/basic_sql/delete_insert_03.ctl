/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance
check there is no next key lock

NUM_CLIENTS = 2
prepare (1,2,4)
C1: delete(2)
C2: insert(3)
check C2 no block
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
C1: insert into t values(2,'abc');
C1: insert into t values(4,'abc');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: delete from t where id=2;
MC: wait until C1 ready;
C2: insert into t values(3,'abc3');
MC: wait until C2 ready;

C1: commit work;
MC: wait until C1 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

