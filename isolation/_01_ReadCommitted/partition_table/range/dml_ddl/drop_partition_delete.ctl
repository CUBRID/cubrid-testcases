/*
Test Case: drop partition & delete
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user drop partition, another delete values

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
C1: alter table t drop partition p2; 
MC: wait until C1 ready;

C2: delete from t where id=1;
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C2 ready;
C2: commit;

/* expected no value */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

