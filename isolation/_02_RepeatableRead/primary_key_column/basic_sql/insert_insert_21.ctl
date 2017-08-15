/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
ON DUPLICATE KEY UPDATE ...
A insert on duplicate ...
B insert the same value with A -- expected waiting
A commit

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(1,'b') on duplicate key update id=2; --expected blocked
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;
C2: insert into t values(1,'b') on duplicate key update id=20;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
/* expected (20,a) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C1 ready;
/* expected (20,a) */
C1: select * from t order by 1,2;
C2: commit;          

C1: commit;
C2: quit;
C1: quit;

