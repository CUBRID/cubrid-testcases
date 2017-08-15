/*
Test Case: insert & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_06.ctl
Author: Rong Xu

Test Point:
If a transaction updates its own inserted record. The record is only visible to its owner until it is committed,
therefore no other transaction can read/modify it
one user insert and then delete in-place

NUM_CLIENTS = 2
C1: insert(2)
C2: insert(3)
C1: delete from t where id=2;
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
C1: insert into t values(2,'abc');
MC: wait until C1 ready;

C2: insert into t values(3,'abc');
MC: wait until C2 ready;

/* expected delete 1 row */
C1: delete from t where id=2;

/* expected select no row */
C1: select * from t order by 1;
C1: commit;
MC: wait until C1 ready;

/* expected select (3,abc) */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

