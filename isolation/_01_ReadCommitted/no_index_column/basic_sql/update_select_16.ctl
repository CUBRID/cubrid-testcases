/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data or changes committed after the query started are never seen;
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
C1, C2 update, no-overlap; C3 select

NUM_CLIENTS = 3
C1: update on table t1, commited
C2: update on table t1, commited after C3 start
C3: select on table t1. there are two versions for the specific rows.
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
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'ghijk'),(4,'lmn'),(5,'opq');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set col='aaa' where id=1;
C1: commit;
MC: wait until C1 ready;
C2: update t1 set col='bbb' where col='opq';
MC: wait until C2 ready;
C3: select t1.* from (select sleep(20)) x, t1 order by 1;
MC: sleep 5;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;

C1: select * from t1 order by 1;
C2: select * from t1 order by 1;
C3: select * from t1 order by 1;
C1: rollback;
C2: rollback;
C3: rollback;
MC: wait until C1 ready;
MC: wait until C2 ready;
MC: wait until C3 ready;


C1: quit;
C2: quit;
C3: quit;
