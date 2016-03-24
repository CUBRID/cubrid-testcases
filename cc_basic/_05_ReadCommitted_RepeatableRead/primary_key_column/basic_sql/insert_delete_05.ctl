/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
If a transaction updates its own inserted record. The record is only visible to its owner until it is committed,
therefore no other transaction can read/modify it
one user insert, another insert, then delete user1's value

NUM_CLIENTS = 2
prepare(1,abc)(4,abc)
C1: begin
C2: insert into t values(2,'abc');
C2: commit;
C1: insert into t values(3,'abc');
C1: delete from t where id>0; -- delete 3 row
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(4,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t order by 1;
MC: wait until C1 ready;
C2: insert into t values(2,'abc');
C2: commit;
MC: wait until C2 ready;
C1: insert into t values(3,'abc');
/* expect delete 3 row */
C1: select * from t order by 1;
C1: delete from t where id>0;
/* expect none */
C1: select * from t order by 1;
C1: commit;
/* expect (2,abc) */
C1: select * from t order by 1;
C1: commit;

C2: quit;
C1: quit;

