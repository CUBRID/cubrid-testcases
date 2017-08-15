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
C2: select twice - before C1 commit, after C1 commit
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1(id int, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc'),(3,'gh'),(9,'def'),(10,'abc'),(11,'gh'),(15,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id=id+2 where id>5;
MC: wait until C1 ready;
C2: select t1.* from (select sleep(10)) x, t1 where id>0 order by 1,2;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;

C2: select * from t1 where id>0 order by 1,2;
MC: wait until C2 ready;

C1: quit;
C2: quit;
