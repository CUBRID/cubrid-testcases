/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
two unique index,there are overlap

NUM_CLIENTS = 2
C1: insert into t values(8,'def');
C2: update t set id=9,col='def' where id=7; --expected blocked
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int unique,col varchar(10) unique);
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(8,'def');
MC: wait until C1 ready;
C2: update t set id=9,col='def' where id=7;
MC: wait until C2 blocked;
C1: rollback;
C2: commit;
/* expected (9,def)*/
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;
