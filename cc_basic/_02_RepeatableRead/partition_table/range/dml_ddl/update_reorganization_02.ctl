/*
Test Case: reorganization partition & select
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user reorganization partition, another update to value that there is no Appropriate partition

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C1: commit;
MC: wait until C2 ready;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10) ) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: insert into t values(12,'ab');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=99 where id=1;
MC: wait until C1 ready;
C2: alter table t reorganize partition p1 into(partition p1_1 values less than (5),partition p1_2 values less than (10));
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;

/* expect (1,'abc')(12,'ab') */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

/* expected (99,'abc')(12,'ab') */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

