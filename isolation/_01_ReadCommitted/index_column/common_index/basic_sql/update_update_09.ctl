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
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(4,'ijk'),(5,'abc');
C1: create index idx on t1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=4 where id=3;
MC: wait until C1 ready;
/* C2 is not blocked and update 1 row */
C2: update t1 set id=5 where id=4;
MC: wait until C2 ready;
/* C1 cannot see C2's update result (5, 'ijk')*/
/* C2 cannot see C1's update result (4, 'abc')*/
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
/* C3 can see both updates' result*/
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;

