/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
X_LOCK on first key OID for unique indexes
two clients insert the same row at the same time, expected no block

NUM_CLIENTS = 2
C1: insert(1,'abc');
C2: insert(1,'abc'); -- expected no block
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1,2;
MC: wait until C2 ready;

C1: insert into t values(1,'abc');
MC: wait until C1 ready;

C2: insert into t values(1,'abc');
MC: wait until C2 ready;

/* expect (1,abc) */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect (1,abc) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expect ((1,abc)(1,abc) */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

