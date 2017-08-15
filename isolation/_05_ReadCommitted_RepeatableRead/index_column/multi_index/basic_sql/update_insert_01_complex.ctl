/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
insert should lock all the unique index 

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10) unique);
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(7,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expect violate unique constraint */
C1: update t set col='abc',id=2 where col='c'; 
C1: update t set col='abc',id=3 where col='c';
MC: wait until C1 ready;

C2: insert into t values(5,'c');
MC: wait until C2 blocked;

C3: insert into t values(3,'dd');
MC: wait until C3 blocked;

C1: rollback;
MC: wait until C1 ready;

/* expect violate unique constraint */
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

/* expect OK */
MC: wait until C3 ready;
C3: commit;
MC: wait until C3 ready;

/* expect (1,a)(2,b)(7,c)(3,dd) */
C1: select * from t order by 1,2; 
C1: commit;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
