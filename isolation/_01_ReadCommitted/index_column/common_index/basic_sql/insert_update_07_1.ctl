/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
two unique index,insert using index1, and update using index2
there is overlap

NUM_CLIENTS = 3
prepare (1,a)(2,b)(7,c)
C1: update t set id=4,col='d' where col='c';
C2: insert into t values(4,'abc');
C3: insert into t values(5,'c');
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int unique,col varchar(10) unique);
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(7,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=4,col='d' where col='c';
MC: wait until C1 ready;

C2: insert into t values(4,'abc');
MC: wait until C2 blocked;

C3: insert into t values(5,'c');
MC: wait until C3 blocked;

/* expected (1,a)(2,b)(4,d) */
C1: select * from t order by 1;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

/* expected (1,a)(2,b)(4,d) */
C2: select * from t order by 1;
MC: wait until C2 ready;

/* expected (1,a)(2,b)(4,d)(5,c) */
C3: select * from t order by 1;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C3: commit;
MC: wait until C3 ready;

C2: quit;
C1: quit;
C3: quit;
