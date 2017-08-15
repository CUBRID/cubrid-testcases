/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
two clients insert the same row at the same time, the first rollback
If the first transaction rollbacks, the second can proceed with updating the original record, re-evaluate
only the first key conflict, check not block each other

NUM_CLIENTS = 2
C1: insert(1,1);
C2: insert(1,2);
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10));
C1: create unique index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'1');
MC: wait until C1 ready;
C2: insert into t values(1,'2');
MC: wait until C2 ready;
C1: commit work;
C2: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;

/* expect (1,1)(1,2) */
C2: select * from t order by 1,2,2;
C2: commit;

C1: quit;
C2: quit;

