/*
Test Case: update & select 
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test update null data in partition table
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data are never seen
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time check delete dose not block select

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
C1: create table t1(id int, col varchar(10)) partition by list (id) (partition p0 values in (1,3,5,7,null), partition p1 values in (2,4,6,8));
C1: insert into t1 values(1,'abc'),(2,'def'),(3,'abc'),(4,'def'),(5,'gh'),(6,'abc'),(null,'abc'),(null,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* before update null is in p0; after update null is still in p0 */
C1: update t1 set id=3 where id is null;
C1: select * from t1 partition(p0) order by 1,2;
C1: select * from t1 partition(p1) order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 partition(p0) order by 1,2;
C2: select * from t1 partition(p1) order by 1,2;
MC: wait until C2 ready;
C1: commit;
C1: select * from t1 partition(p0) order by 1,2;
C1: select * from t1 partition(p1) order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 partition(p0) order by 1,2;
C2: select * from t1 partition(p1) order by 1,2;
C2: commit;
MC: wait until C2 ready;


C1: quit;
C2: quit;
