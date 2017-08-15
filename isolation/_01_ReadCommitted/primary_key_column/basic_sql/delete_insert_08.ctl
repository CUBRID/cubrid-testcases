/*
Test Case: delete & insert 
Priority: 1
Reference case:
Author: Rong Xu

Test Point: 
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance
one user delete a empty table, another insert

NUM_CLIENTS = 2 
C1: delete empty table
C2: insert into t values(1);
check no block, result is right
C1: rollback
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
C1: delete from t;
MC: wait until C1 ready;
C2: insert into t values(1,'col');
MC: wait until C2 ready;
C1: rollback work;
MC: wait until C2 ready;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

