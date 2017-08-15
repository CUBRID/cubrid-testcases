/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
If a transaction updates its own inserted record. The record is only visible to its owner until it is committed,
therefore no other transaction can read/modify it
one user insert and then delete in-place, another user insert
insert different row, both value less than a value
check no next key lock

NUM_CLIENTS = 2
C1: insert (6);
C1: insert (4);
C2: insert (5);
C1: delete from t;
check no block
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(6,'abc');
C1: insert into t values(4,'abc');
MC: wait until C1 ready;
/* expect no value */
C2: select * from t order by 1,2;
C2: insert into t values(5,'abc');
MC: wait until C2 ready;
/* expect delete 4,6 */
C1: delete from t;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
/* expect no value */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect (5,abc) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

