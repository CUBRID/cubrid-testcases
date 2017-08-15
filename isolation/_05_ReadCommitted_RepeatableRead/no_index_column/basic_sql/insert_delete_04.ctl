/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_05.ctl
Author: Lily

Test Point:
If a transaction updates its own inserted record. The record is only visible to its owner until it is committed,
therefore no other transaction can read/modify it
one user insert, another insert, then delete user1's value

NUM_CLIENTS = 2
C1: insert into t values(2,'abc');
C2: insert into t values(3,'abc');
C2: delete from t where id=2; --can not see C1 insert value
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(4,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: insert into t values(3,'abc');
C2: delete from t where id=2;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;
C2: delete from t where id=2;
C2: commit;
/* expect 1,2,3,4 */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

