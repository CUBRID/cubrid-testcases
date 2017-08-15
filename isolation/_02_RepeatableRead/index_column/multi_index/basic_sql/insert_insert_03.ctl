/*
Test Case: insert & insert
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
insert should lock all the unique index 

NUM_CLIENTS = 2
C2: begin
C1: insert into t values(1,'a');
C1: insert into t values(3,'c');
C2: insert into t values(2,'b'); --ready, only can see itself
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10) unique);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1,2;
MC: wait until C2 ready;
C1: insert into t values(1,'a');
C1: insert into t values(3,'c');
MC: wait until C1 ready;
C2: insert into t values(2,'b');
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;
/* expect (2,b) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: select * from t order by 1,2;
C1: commit;

C1: quit;
C2: quit;

