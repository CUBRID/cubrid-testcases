/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_01.ctl
Author: Lily

Test Point:
one user insert and then delete in-place, another user insert the same value

NUM_CLIENTS = 2
C1: insert(1)
C2: insert(1) -- insert successfully
C1: delete(1) -- delete successfully
C1: commit
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
C2: insert into t values(1,'abc');
MC: wait until C2 ready;
C1: delete from t where id=1;
C1: commit work;
MC: wait until C1 ready;
C2: commit;
/* expect only one row - (1,'abc') */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

