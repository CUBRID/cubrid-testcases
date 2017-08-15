/*
Test Case: update & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/update_update_06.ctl
Author: Mandy

Test Point:
A target record may be already locked and modified (updated or deleted) by another transaction. In this case:
1. current transaction will wait for the first updating transaction to commit or rollback.
2. if the record was updated and a new version was created, the second transaction will try to update the latest committed version after re-evaluating the search condition: if the search condition is still satisfied, the object may be updated, otherwise it is ignored.
In this case, the first transaction's update result will affect the second transaction's search key value. In this case, the transation is not blocked. And the search condition is not re-evaluate because the first transaction is not commited yet, check the second update is executed correctly.

NUM_CLIENTS = 3
C1: update on table t1; commit after C2 update
C2: update on table t1; does not re-evaluate and update
C3: select on table t1, and C3 is used to check the update result. Expected: 0,1,2,4,5
*/


MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int primary key, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(4,'ijk');insert into t1 values(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=0 where id=3 and col='abc';
MC: wait until C1 ready;
C2: update t1 set id=7 where id=0 and col='abc';
MC: wait until C2 ready;
C1: select * from t1 order by 1;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C1: select * from t1 order by 1;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C1: select * from t1 order by 1;
MC: wait until C1 ready;
C2: select * from t1 order by 1;
MC: wait until C2 ready;
C3: select * from t1 order by 1;

C3: commit;
C2: commit;
C1: commit;
C1: quit;
C2: quit;
C3: quit;

