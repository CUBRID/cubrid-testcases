/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Bobo

Test Point:
Test the visibility before commit and after commit
1. Reading transactions can only have a look at data committed before the transactions began
2. Uncommitted data are never seen

NUM_CLIENTS = 2 
C1: select on table t1 before C2 commit/rollback
C2: update and select on table t1
C1: select on table t1 after C2 commit/rollback
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(1,'gh');insert into t1 values(1,'abc');insert into t1 values(4,'def');insert into t1 values(5,'ijk');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id=1 order by col;
MC: wait until C1 ready;

C2: update t1 set col='aa' where id=1;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

C2: rollback;
MC: wait until C2 ready;

C1: select * from t1 where id=1 order by col;
C1: select * from t1 order by 1,2;
C1: rollback;
C1: select * from t1 where id=1 order by col;
MC: wait until C1 ready;

C2: update t1 set col='bb' where id=1;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

C2: rollback;
MC: wait until C2 ready;

C1: select * from t1 where id=1 order by col;
C1: select * from t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

C1: select * from t1 where id=1 order by col;
MC: wait until C1 ready;

C2: update t1 set col='cc' where id=1;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from t1 where id=1 order by col;
C1: select * from t1 order by 1,2;
C1: rollback;
MC: wait until C1 ready;

C1: select * from t1 where id=1 order by col;
MC: wait until C1 ready;

C2: update t1 set col='dd' where id=1;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C1: select * from t1 where id=1 order by col;
C1: select * from t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

C1: quit;
C2: quit;
