/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
ON DUPLICATE KEY UPDATE ...
A insert on duplicate ...
B insert the same value with A -- expected waiting
A rollback

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(1,'b') on duplicate key update id=id+10; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;
C2: insert into t values(1,'b') on duplicate key update id=id+20;
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;
MC: wait until C1 ready;
/* expected (20,a) */
C1: select * from t order by 1,2;
C2: commit;          

C2: quit;
C1: quit;

