/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
A target record may be already locked and modified (updated or deleted) by another transaction. In this case:
1. current transaction will wait for the first updating transaction to commit or rollback
2. If the first transaction deletes the row and commits, the record can no longer be updated
3. Current transaction can see its own uncommitted data
one user delete some rows, another insert the rows which modify the delete clause

NUM_CLIENTS = 2
prepare (3,7)
C1: delete from t where id <8;
C2: insert into t values(2,'abc');
check C2 no block
C2: check select values
C1: rollback
C2: check select values
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
C1: delete from t where id <8;
MC: wait until C1 ready;
C2: insert into t values(2,'abc');
MC: wait until C2 ready;

/* check C2 can read C1 delete value, and its insert value */
C2: select * from t order by 1;

C1: rollback work;
C2: commit;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

