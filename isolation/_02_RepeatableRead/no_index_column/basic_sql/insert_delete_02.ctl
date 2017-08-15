/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_02.ctl
Related Issue: CUBRIDSUS-14634/CUBRIDSUS-14158
Author: Lily

Test Point:
If a transaction updates its own inserted record. The record is only visible to its owner until it is committed,
therefore no other transaction can read/modify it
one user insert and then delete in-place, another delete the whole table

NUM_CLIENTS = 2
C1: insert(1)
C2: delete from t --ready, can not see insert value
C1: delete(1)   --ok, can see its owner
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
C1: insert into t values(2,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
C2: delete from t;
MC: wait until C2 ready;
C1: commit work;
/* expect (no data) */
MC: wait until C2 ready;
C2: select * from t order by 1;
C2: commit;
/* expect (1,'abc') */
C1: select * from t order by 1;

C1: commit;
C2: quit;
C1: quit;

