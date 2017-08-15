/*
Test Case: reorganization partition & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user reorganization partition, another alter value in P1 to P2

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C1: commit work;
MC: wait until C2 ready;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: insert into t values(12,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t reorganize partition p1 into(partition p1_1 values less than (5),partition p1_2 values less than (10));
MC: wait until C1 ready;
C2: update t set id=11 where id=1;
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;

/* expected no value */
C2: select * from t__p__p1_1 order by 1;
MC: wait until C2 ready;

/* expected (11,abc)(12,abc) */
C2: select * from t__p__p2 order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

