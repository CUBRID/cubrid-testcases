/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance 
insert using primary key index, and delete do not use index

NUM_CLIENTS = 2
prepare (1,2,7)
C1: delete from t where col='abc';
C2: insert into t values(1,'abc'); --expected error
C1: select * from t order by 1; --expected no value
C1: rollback work;
C1: select * from t order by 1; --expected 1,2,7
C2: commit;
C2: select * from t order by 1; --expected 1,2,7
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
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where col='abc';
MC: wait until C1 ready;

C2: insert into t values(1,'abc');
MC: wait until C2 blocked;

C1: select * from t order by 1;
MC: wait until C1 ready;
C1: rollback work;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: select * from t order by 1;
MC: wait until C1 ready;

C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

