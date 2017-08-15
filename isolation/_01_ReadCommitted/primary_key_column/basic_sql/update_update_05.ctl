/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
In this case, the first transaction's update result will affect the second transaction's search key value. In this case, the tran
sation is not blocked. Check the second update is executed correctly.

NUM_CLIENTS = 3
C1: update on table t1; commit
C2: update on table t1; is not blocked, does not re-evaluate and does not update
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
C1: create table t1(id int primary key, col varchar(10));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(4,'ijk'),(5,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=0 where id=3;
MC: wait until C1 ready;
/* C2 is not blocked and update 0 row */
C2: update t1 set col='bb' where id=0;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
/* check C2 does not change abc to bb*/
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

