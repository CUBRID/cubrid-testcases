/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
two clients insert the same row at the same time

NUM_CLIENTS = 2
C1: insert(2);
C2: insert(2);  --blocked
C1: commit
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
C1: insert into t values(2,'abc3');
MC: wait until C1 ready;

C2: insert into t values(2,'abc4');
MC: wait until C2 blocked;

C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

