/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_04.ctl
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Update: X_LOCK acquired on current instance
one user insert, another update other row

NUM_CLIENTS = 3
C1: insert(8);
C2: update t set id=9 where id=7; --expected ready
C3: update t set id=8 where id=7; --expected blocked
C1: commit
C2: commit
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
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id);
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: update t set id=9 where id=7;
MC: wait until C2 ready;
C3: update t set id=8 where id=7;
MC: wait until C3 blocked;
C1: commit work;
C2: commit;
MC: wait until C3 ready;
C3: commit;
C3: select * from t order by 1;
C3: commit;

C1: quit;
C2: quit;
C3: quit;
