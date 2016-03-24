/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_02.ctl
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
two clients insert many row at the same time

NUM_CLIENTS = 2
C1: insert(1)(2)(1);
C2: insert(1)(3)(1);
C1: rollback -- 0 row insert
C2: commit 2 row insert
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10));
C1: create unique index idx on t(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
C1: insert into t values(2,'abc');
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
C2: insert into t values(1,'abc');
MC: wait until C2 blocked;
C1: rollback work;
MC: wait until C2 ready;
C2: insert into t values(3,'abc');
C2: insert into t values(1,'abc');
C2: commit work;
MC: wait until C2 ready;

/* expect (1,abc)(3,abc) */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;

