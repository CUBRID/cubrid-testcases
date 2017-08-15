/*
Test Case: add partition & insert
Priority: 1
Reference case:
Author: Rong Xu
Test Point:
one user add partition, another insert values

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: insert into t values(11,'ab');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(20,'a');
MC: wait until C1 ready;
C2: alter table t add partition(partition p3 values less than (3000)); 
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit;

/* expected (1,abc)(11,ab)(20,a) */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

