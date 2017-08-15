/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
two clients insert the different row which have the same trim value
NUM_CLIENTS = 2
C1: insert('a ');
C2: insert(' a');
C1: commit -- 1 row insert, no block
C2: commit -- 1 row insert,no block
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a ');
MC: wait until C1 ready;

C2: insert into t values(1,' a');
/*MC: wait until C2 blocked;*/
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: commit;
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

