/*
Test Case: update & update
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/update_update12.ctl
Author: Mandy

Test Point:
A target record may be already locked and modified (updated or deleted) by another transaction. In this case:
1. current transaction will wait for the first updating transaction to commit or rollback.
2. if the first transaction rollbacks, the second can proceed with updating the original record.
In this case, C3 is blocked by C2 after C1 commit.
C1 update; then C2 and C3 update at the same time.

NUM_CLIENTS = 4
C1: update on table t1
C2: update on table t1;if C3 get the lock first, C2 will re-evaluate and dose nothing
C3: update on table t1;if C2 get the lock first, C3 will re-evlauate and update
C4: C4 select on table t1, this client is used to check the update result
*/


MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10), primary key(id,col));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(3,'def'),(4,'abd'),(5,'abcd'),(6,'ab');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set col='aa' where id<6 and col like 'abc%';
MC: wait until C1 ready;
C2: update t1 set col='bb' where id>3 and id<6 and col like 'ab%';
C3: update t1 set col='cc' where id>1 and col like 'a%'; 
MC: wait until C2 blocked;
MC: wait until C3 blocked;
C1: commit;
MC: wait until C2 ready;
C2: commit;
MC: wait until C3 ready;
C3: commit;
MC: wait until C3 ready;
C4: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
C4: quit;

