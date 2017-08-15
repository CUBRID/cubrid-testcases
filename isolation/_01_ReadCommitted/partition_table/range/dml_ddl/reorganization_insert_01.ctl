/*
Test Case: reorganization partition & delete
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user reorganization partition, another insert some row

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: insert into t values(12,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t reorganize partition p1 into(partition p1_1 values less than (2),partition p1_2 values less than (10)); 
MC: wait until C1 ready;
C2: insert into t values(3,'abc'),(1,'ab');
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit;

/* expected (1,abc)(1,ab) */
C2: select * from t__p__p1_1 order by 1;
/* expected (3,abc) */
C2: select * from t__p__p1_2 order by 1;
/* expected (12,abc) */
C2: select * from t__p__p2 order by 1;
C2: commit;

C2: quit;
C1: quit;

