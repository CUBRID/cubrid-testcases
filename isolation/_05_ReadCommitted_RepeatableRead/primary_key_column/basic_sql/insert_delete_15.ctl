/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
If a transaction updates its own inserted record. The record is only visible to its owner until it is committed,
therefore no other transaction can read/modify it
one user insert, another delete the whole table

NUM_CLIENTS = 2
prepare(1,'a')
C1: begin
C2: delete from t; commit; 
C1: insert(1) -- can not insert, since it can not see C1's delete
C1: select * from t order by 1; -- (1,'a')
C1: commit
C1: select * from t order by 1; -- values should be none
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t order by 1,2;
MC: wait until C1 ready;
C2: delete from t;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected failed, can not see C1's commit */
C1: insert into t values(1,'abc');
MC: wait until C1 blocked;
C2: commit;
/* expect id value: 1 a */
MC: wait until C1 ready;
C1: select * from t order by 1,2;
C1: commit;

/* expect id value: none */
C1: select * from t order by 1,2;
C1: commit;

C2: quit;
C1: quit;

