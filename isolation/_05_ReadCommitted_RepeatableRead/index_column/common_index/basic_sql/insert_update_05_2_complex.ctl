/*
Test Case: insert & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_update_05.ctl
Author: Rong Xu
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes. 
-    Update: X_LOCK acquired on current instance 
one user insert, another update the same row
index on two column

NUM_CLIENTS = 2
C1: insert into t values(1,'abc');
C2: update t set id=2 where id=1 and col='abc'; --expecte 0 row affected 
C1: commit
C2: commit
C3: insert into t values(2,'abc'); --expecte blocked
C4: update t set id=2 where id=1 and col='abc'; --expecte blocked
C3: commit
C4: commit
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
/* 0 row affected */
C2: update t set id=2 where id=1 and col='abc';
MC: wait until C2 ready;
C3: insert into t values(2,'abc2');
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
/* 0 row affected */
C4: update t set id=2 where id=1 and col='abc';
MC: wait until C4 ready;
C3: commit;
MC: wait until C4 ready;
C4: commit;
MC: wait until C4 ready;

C2: select * from t order by 1,2;
C2: commit;

C1: quit;
C2: quit;
C3: quit;
C4: quit;

