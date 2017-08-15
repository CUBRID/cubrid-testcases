/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
A target record may be already locked and modified (updated or deleted) by another transaction. In this case:
1. current transaction will wait for the first updating transaction to commit or rollback
2. If the first transaction deletes the row and commits, the record can no longer be updated
one user delete the whole table, another insert

NUM_CLIENTS = 2
prepare (3,7)
C1: delete * from t;
C2: insert into t values(7);  -- 7 has been locked by C1
check C2 blocked, wait until C1 commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: delete from t;
MC: wait until C1 ready;
C2: insert into t values(7,'abc');
MC: wait until C2 blocked;
C1: commit work;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

