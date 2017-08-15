/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
cause deadlock, wait deadlock resolution

NUM_CLIENTS = 2
C1: insert(1);
C2: insert(2);
C1: insert(2);
C2: insert(1);
wait deadlock resolution
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;

MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1;
MC: wait until C2 ready;

C1: insert into t values(1,'abc');
MC: wait until C1 ready;

C2: insert into t values(2,'abc');
MC: wait until C2 ready;

C1: insert into t values(2,'abc');
MC: wait until C1 blocked;

C2: insert into t values(1,'abc');
MC: wait until C2 blocked;
MC: pause for deadlock resolution;

C1: commit work;
MC: wait until C1 ready;

C2: commit work;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

