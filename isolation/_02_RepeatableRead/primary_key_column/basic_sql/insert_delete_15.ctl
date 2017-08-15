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
C2: begin
C1: delete from t; commit; 
C2: insert(1) -- can not insert, since it can not see C1's delete
C2: select * from t order by 1; -- (1,'a')
C2: commit
C2: select * from t order by 1; -- values should be none
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1,2;
MC: wait until C2 ready;
C1: delete from t;
MC: wait until C1 ready;
C2: commit;
/* expected failed, can not see C1's commit */
C2: insert into t values(1,'abc');
MC: wait until C2 blocked;
C1: commit;
/* expect id value: 1 a */
MC: wait until C1 ready;
C2: select * from t order by 1;
C2: commit;

/* expect id value: none */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

