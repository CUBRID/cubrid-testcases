/*
Test Case: update & update
Priority: 1
Reference case:
Author: Mandy

Test Point:
C1 update, C2 update, the affected rows are overlapped, one is updating the whole table.

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
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(1,'def');insert into t1 values(4,'gh');
C1: commit work;
MC: wait until C1 ready;

/* C1 update, C2 update*/
C1: update t1 set col='aa';
MC: wait until C1 ready;
C2: update t1 set col='bb' where id<3;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from t1 order by 1,2;

C3: commit;
C1: quit;
C2: quit;
C3: quit;
