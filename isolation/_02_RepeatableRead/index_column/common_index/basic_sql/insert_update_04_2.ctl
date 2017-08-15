/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_04.ctl
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
one user insert, another update other row
unique index

NUM_CLIENTS = 2
C2: update t set id=9 where id=7;
C1: insert(8); --expected ready
C1: commit
C2: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id);
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=9 where id=7;
MC: wait until C1 ready;
C2: insert into t values(8,'abc');
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
