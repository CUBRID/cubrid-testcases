/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. changes committed after the query started are never seen

NUM_CLIENTS = 2
C1: update, commit after C2's query start
C2: select three times - before C1 commit, after C1 commit, after C2 commit.
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1(id int primary key, col varchar(10)) partition by list (id) (partition p0 values in (1,3,5,7), partition p1 values in (2,4,6,8));
C1: insert into t1 values(1,'abc'),(3,'def'),(6,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* cross partitions, one partition is empty after update */
C1: update t1 set id=id+1 where id<5;
MC: wait until C1 ready;
C2: select *, sleep(2) from t1 where id>0 order by 1,2;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1 where id>0 order by 1,2;
C2: commit;
MC: wait until C2 ready;


C1: quit;
C2: quit;
