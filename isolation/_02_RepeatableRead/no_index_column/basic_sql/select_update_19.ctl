/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Bobo

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data are never seen
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction

NUM_CLIENTS = 2 
C1: select on table t1 before C1 commit
C2: update and select on table t1
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10));
C1: commit;
MC: wait until C1 ready;
C1: insert into t1 values(1,'abc');insert into t1 values(2,'def');insert into t1 values(3,'abc');insert into t1 values(1,'gh');insert into t1 values(1,'abc');insert into t1 values(4,'def');insert into t1 values(5,'ijk');insert into t1 values(6,'lmn');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: select * from t1 where id=1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set col='ab' where id=1;
C2: select * from t1 where id=1 order by 1,2;
MC: wait until C2 ready;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=2 where id=3;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;

/* this case is almost the same as the case above, but in this one, C1 commit at the end of the transaction */
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=2 where id=3;
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=3 where col='def';
C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: rollback;
MC: wait until C2 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=4 where id=1;
C2: select * from t1 where col='abc' order by 1,2;
MC: wait until C2 ready;
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;

/* overlap test */
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;
C2: update t1 set id=7 where col='def';
MC: wait until C2 ready;
C1: select * from t1 where id>3 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where id>3 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
