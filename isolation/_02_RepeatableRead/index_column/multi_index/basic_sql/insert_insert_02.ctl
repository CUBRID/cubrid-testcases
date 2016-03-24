/*
Test Case: insert & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
insert should lock all the unique index 

NUM_CLIENTS = 3
C1: insert into t values(1,'a');
C2: insert into t values(1,'c'); -- blocked by c1,c3
C3: insert into t values(2,'c');
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

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
/* C3 is blocked by C2 */
C3: insert into t values(2,'c');
MC: wait until C3 blocked;

C1: commit;

MC: wait until C2 ready;
C2: select * from t order by 1,2;
/* C3 is blocked by C2 */
MC: wait until C3 blocked;
C2: commit;

MC: wait until C3 ready;
C3: select * from t order by 1,2;
C3: commit;
MC: wait until C3 ready;

/* expected (1,a)(2,c) */
C1: select * from t order by 1,2;
C1: commit;

C1: quit;
C2: quit;
C3: quit;

