/*
Test Case: remove partition & update
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user remove partition, then another update value from P1 to value for which there is no appropriate partition

NUM_CLIENTS = 2
C1: alter table t remove partitioning;
C2: update t set id=120 where id=1; 
C1: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (200));
C1: insert into t values(1,'abc');
C1: insert into t values(12,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t remove partitioning;
MC: wait until C1 ready;
C2: update t set id=120 where id=1; 
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
/* expected ok */
C2: commit;
/* expected (120,abc)(12,abc) */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

