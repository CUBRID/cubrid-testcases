/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
insert using primary key index, and update do not use index

NUM_CLIENTS = 2
prepare (1,2,7)
C1: insert into t values(4,'abc');
C2: update t set id=4 where col='c'; --expected block, because modify the same column
MC: wait until C2 blocked;
C1: select * from t order by 1; --1,2,7,4
C1: rollback work;
MC: wait until C2 ready;
C1: select * from t order by 1; --expected 1,2,7
C2: commit;          --expected C2 update ok 
C2: select * from t order by 1; --expected 1,2,(4,'c')
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(7,'c');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: insert into t values(4,'abc');
MC: wait until C1 ready;
C2: update t set id=4 where col='c'; 
MC: wait until C2 blocked;
C1: select * from t order by 1; 
C1: rollback work;
MC: wait until C2 ready;
C1: select * from t order by 1;
MC: wait until C1 ready; 
C2: commit;          
C2: select * from t order by 1; 
C2: commit;

C2: quit;
C1: quit;

