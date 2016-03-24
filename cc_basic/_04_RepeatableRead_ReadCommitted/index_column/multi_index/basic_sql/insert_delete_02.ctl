/*
Test Case: insert & delete
Priority: 1
Reference case: 1
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance
two unique index

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col int unique);
C1: create unique index idx on t(id,col);
C1: insert into t values(1,1);insert into t values(1,2);insert into t values(4,3);insert into t values(4,4);insert into t values(1,5);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where id=1;
MC: wait until C1 ready;

C2: insert into t values(2,1);insert into t values(2,2);insert into t values(2,5);
MC: wait until C2 blocked;

C1: commit;
MC: wait until C2 ready;

C2: commit;          

/* expected (4,3),(4,4),(2,1),(2,2),(2,5) */
C2: select * from t order by 1,2; 
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
