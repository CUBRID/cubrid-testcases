/*
Test Case: update & select
Priority: 1
Reference case:
Author: Bobo

Test Point:
1. Reading transactions can only have a look at data committed before the transactions began
2. Uncommitted data or changes committed after the transaction started are never seen;
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
C1, C3 select; C2, C4 update, no-overlap

NUM_CLIENTS = 4
C1: select on table t1, commited 
C2: update on table t1, commited
C3: select on table t1. there are two versions for the specific rows.
C4: update on table t1, not commited
*/


MC: setup NUM_CLIENTS = 4;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t1;
C1: commit work;
C1: create table t1(id int, col varchar(10));
C1: insert into t1 values(1,'abc');
C1: insert into t1 values(2,'def');
C1: insert into t1 values(3,'ghijk');
C1: insert into t1 values(4,'lmn');
C1: insert into t1 values(5,'opq');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: update t1 set col='aaa' where id=1;
MC: wait until C2 ready;

C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C2: commit;
MC: wait until C2 ready;

C4: update t1 set col='bbb' where col='opq';
MC: wait until C4 ready;

C1: select t1.* from t1 order by 1,2;
MC: wait until C1 ready;

C4: commit;
MC: wait until C4 ready;

C1: commit;
MC: wait until C1 ready;
C3: commit;
MC: wait until C3 ready;

C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

C2: select * from t1 order by 1,2;
MC: wait until C2 ready;

C3: select * from t1 order by 1,2;
MC: wait until C3 ready;

C4: select * from t1 order by 1,2;
MC: wait until C4 ready;

C1: rollback;
MC: wait until C1 ready;

C2: rollback;
MC: wait until C2 ready;

C3: rollback;
MC: wait until C3 ready;

C4: rollback;
MC: wait until C4 ready;


C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;

C3: commit;
MC: wait until C3 ready;

C4: commit;
MC: wait until C4 ready;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
