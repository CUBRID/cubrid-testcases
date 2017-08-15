/*
Test Case: insert & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_08.ctl
Author: Rong Xu

Test Point:
Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
one user insert and then delete in-place, another user insert the same row
the first user rollback

NUM_CLIENTS = 2
C1: insert into t values(1,'abc');
C2: insert into t values(1,'abc');
C2: delete from t where id=1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10));
C1: create index idx on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;

C2: insert into t values(1,'abc');
MC: wait until C2 ready;
C1: delete from t where id=1;
C1: rollback work;
MC: wait until C1 ready;

C2: commit;
/* expected 0 row selected */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;

