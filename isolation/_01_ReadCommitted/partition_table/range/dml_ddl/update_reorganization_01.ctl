/*
Test Case: reorganization partition & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user reorganization partition, another alter value from p1_1 to P1_2

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
C1: insert into t values(2,'abc');
C1: insert into t values(9,'abc');
C1: insert into t values(12,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t reorganize partition p1 into(partition p1_1 values less than (5),partition p1_2 values less than (10));
MC: wait until C1 ready;

C2: update t set id=8 where id=1;
MC: wait until C2 blocked;

C1: commit work;
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;

/* expected no value */
C2: select * from t__p__p1_1 order by 1;

/* expected (8,abc) */
C2: select * from t__p__p1_2 order by 1;

/* expected (12,abc) */
C2: select * from t__p__p2 order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

