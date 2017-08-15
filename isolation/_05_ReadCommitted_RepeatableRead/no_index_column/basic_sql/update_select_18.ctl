/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Bobo

Test Point:
C1 update, C2 select, the affected rows are not overlapped.

NUM_CLIENTS = 2 
C1: update on table t1  
C2: Select on table t1  
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');
C1: insert into t1 values(2,'def');
C1: insert into t1 values(3,'abc');
C1: insert into t1 values(1,'gh');
C1: insert into t1 values(1,'abc');
C1: insert into t1 values(4,'def');
C1: insert into t1 values(5,'ijk');
C1: insert into t1 values(6,'lmn');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=6 where id=5;
MC: wait until C1 ready;
C2: select * from t1 where id = 1 order by 1,2;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;

C1: update t1 set id=3 where col='def';
MC: wait until C1 ready;
C2: select * from t1 where id=1 order by 1,2;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;

C1: update t1 set col='ddd' where col='def';
MC: wait until C1 ready;
C2: select * from t1 where id>4 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
