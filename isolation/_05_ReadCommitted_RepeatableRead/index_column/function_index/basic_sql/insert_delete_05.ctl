/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_08.ctl
Author: Rong Xu

Test Point:
one user insert and then delete in-place, another user insert the same row
the first user rollback

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'abc');
MC: wait until C1 ready;
C2: insert into t values(1,'abc');
MC: wait until C2 ready;
C1: delete from t where id=1;
/* expect no value */
C1: select * from t where LENGTH(col)=3;
C1: rollback work;
MC: wait until C1 ready;
/* expect (1,abc) */
C2: select * from t where LENGTH(col)=3;
C2: commit;
/* expected (1,abc)*/
C2: select * from t where LENGTH(col)=3 order by 1;
C2: commit;

C2: quit;
C1: quit;

