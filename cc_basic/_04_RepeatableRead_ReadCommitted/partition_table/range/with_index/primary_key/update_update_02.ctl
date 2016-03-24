/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1 update, C2 update, the affected rows are not overlapped.
In this case, the first transaction's update result will affect the second transaction's search key value. In this case, the tran
sation is not blocked. Check the second update is executed correctly.

NUM_CLIENTS = 3
C1: update on table t1  
C2: update on table t1  
C3: select on table t1; C3 is used to check the update result
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
C1: create table t1(id int primary key, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc');insert into t1 values(9,'def');insert into t1 values(10,'abc');insert into t1 values(12,'gh');insert into t1 values(15,'def');
C1: commit work;
MC: wait until C1 ready;

/* C1 update, C2 update*/
/* the where clause in C1 and C2 dose not cross partitions; C1 and C2 update result cross partitions */
C1: update t1 set id=id+2 where id<10;
MC: wait until C1 ready;
C2: update t1 set id=id-2 where id>10;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from t1 order by 1,2;

C3: commit;
MC: wait until C3 ready;
C1: quit;
C2: quit;
C3: quit;
