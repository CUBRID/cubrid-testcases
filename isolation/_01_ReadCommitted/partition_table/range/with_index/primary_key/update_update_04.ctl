/*
Test Case: update & update 
Priority: 1
Reference case:
Author: Mandy

Test Point: 
A target record may be already locked and modified (updated or deleted) by another transaction. In this case:
1. current transaction will wait for the first updating transaction to commit or rollback. 
2. if the first transaction rollbacks, the second can proceed with updating the original record.

NUM_CLIENTS = 3 
C1: update on table t1; rollback  
C2: update on table t1
C3: select on table t1, and C3 is used to check the update result      
*/


MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int primary key, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc'),(8,'def'),(9,'abc'),(10,'gh'),(11,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* both update do not cross partitions*/
C1: update t1 set col='aa' where id<9;
MC: wait until C1 ready;
C2: update t1 set col='bb' where id<9;
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

