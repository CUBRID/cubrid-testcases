/*
Test Case: insert & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
insert should lock all the unique index 

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(1,'c'); -- blocked by c1,failed after C1 commit
C1: commit;
C2: insert into t values(2,'a'); -- violate unique
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10) unique);
C1: create unique index idx on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;
C2: insert into t values(1,'c');
MC: wait until C2 blocked;

C1: rollback;
MC: wait until C2 ready;

C2: insert into t values(2,'a');
C2: select * from t order by 1,2;
C2: commit;

C2: select * from t order by 1,2;
C2: commit;

C1: quit;
C2: quit;

