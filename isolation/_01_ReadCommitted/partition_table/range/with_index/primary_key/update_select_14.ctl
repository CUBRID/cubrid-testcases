/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test select snapshot from a single partition
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data are never seen
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time check update dose not block select

NUM_CLIENTS = 2 
C1: update and select on table t1
C2: select on table t1 before C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1(id int primary key, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc'),(8,'def'),(11,'abc'),(12,'gh'),(15,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=id+2 where id<10;
C1: select * from t1 partition(p1) order by 1,2;
C1: select * from t1 partition(p2) order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 partition(p1) order by 1,2;
C2: select * from t1 partition(p2) order by 1,2;
MC: wait until C2 ready;
C1: commit;
C1: select * from t1 partition(p1) order by 1,2;
C1: select * from t1 partition(p2) order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 partition(p1) order by 1,2;
C2: select * from t1 partition(p2) order by 1,2;
C2: commit;
MC: wait until C2 ready;


C1: quit;
C2: quit;
