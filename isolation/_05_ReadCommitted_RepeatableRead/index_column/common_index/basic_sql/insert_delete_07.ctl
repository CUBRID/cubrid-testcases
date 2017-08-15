/*
Test Case: insert & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_28.ctl
Author: Rong Xu

Test Point:
-    Insert: X_LOCK on first key OID for unique indexes.
-    Delete: X_LOCK acquired on current instance 
insert using  index, and delete do not use index
C1: create index idx on t(id);

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int ,col varchar(10));
C1: create index idx on t(id);
C1: insert into t values(1,'abc');
C1: insert into t values(2,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by id;
MC: wait until C2 ready;
C1: insert into t values(4,'abc');
C1: commit;
MC: wait until C1 ready;

/* expected delete 3 rows */
C2: delete from t where col='abc';
MC: wait until C2 ready;
/* expect no value to be selected */
C2: select * from t order by 1;
C2: commit;

C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

