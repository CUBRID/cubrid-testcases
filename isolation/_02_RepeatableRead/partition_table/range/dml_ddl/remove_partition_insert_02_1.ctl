/*
Test Case: remove partition & delete
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user remove partition, another insert some row for which there is no appropiate partition

NUM_CLIENTS = 2
C1: alter table t remove partitioning;
C2: insert into t values(200,'abc');
C1: rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: insert into t values(12,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t remove partitioning;
MC: wait until C1 ready;
C2: insert into t values(99,'abc');
MC: wait until C2 blocked;
C1: rollback work;
MC: wait until C2 ready;
/* expected failed */
/* expected (1,abc)(12,abc)(99,'abc') */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C1: select * from t order by 1;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

