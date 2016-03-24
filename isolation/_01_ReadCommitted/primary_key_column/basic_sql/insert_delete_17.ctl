/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
The record is only visible to its owner until it is committed
one user insert, another delete the inserted row

NUM_CLIENTS = 2
C1: insert(4)
C2: insert(4) --delete 0 row
C1: commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: insert into t values(4,'abc');
MC: wait until C1 ready;
C2: delete from t where id=4;
MC: wait until C2 ready;
C1: select * from t order by 1;
C1: commit work;
MC: wait until C1 ready;
C2: select * from t order by 1;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

