/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user insert 1, update 1 to 11, another insert 11, the third update 1

NUM_CLIENTS = 3
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
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=11 where id=1;
C1: insert into t values(1,'abc');
MC: wait until C1 ready;

C2: insert into t values(11,'abc');
MC: wait until C2 blocked;
C3: update t set id=15 where id=1;
MC: wait until C3 blocked;
C1: rollback;
MC: wait until C2 ready;
MC: wait until C3 ready;

/* expect (1,'abc') (11,'abc') */
C2: select * from t order by 1;
MC: wait until C2 ready;

/* expect (15,'abc')*/
C3: select * from t order by 1;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;

C3: quit;
C2: quit;
C1: quit;

