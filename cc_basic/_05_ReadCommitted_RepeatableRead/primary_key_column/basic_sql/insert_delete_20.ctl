/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
The record is only visible to its owner until it is committed
one user insert, another delete the inserted row

NUM_CLIENTS = 2
C1: begin
C2: insert(4) and commit
C1: delete(4) --delete 0 rows
C1: select -- can not see C1's insert
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
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t order by 1,2;
MC: wait until C1 ready;
C2: insert into t values(4,'abc');
C2: commit;

/* expect 0 row delete */
C1: delete from t where id=4;
MC: wait until C1 ready;
C1: commit;

/* expect id value: 1,4 */
C1: select * from t order by 1;
C1: commit;

C2: quit;
C1: quit;

