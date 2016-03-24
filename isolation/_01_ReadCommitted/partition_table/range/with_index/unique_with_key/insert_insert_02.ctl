/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
ON DUPLICATE KEY UPDATE ...
A insert on duplicate ...
B insert the same value with A -- expected waiting
C insert value equals to update
A commit

NUM_CLIENTS = 3
C1: insert into t values(1,'a');
C2: insert into t values(1,'b') on duplicate key update id=id+10; --expected blocked by c1 and c3
C3: insert into t values(21,'a','s');
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10),col1 varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: create unique index idx on t(id,col);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a','c');
MC: wait until C1 ready;
C2: insert into t values(1,'a','d') on duplicate key update id=id+20;
C3: insert into t values(21,'a','s');
MC: wait until C2 blocked;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C3: commit;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
/* expected (42,a) */
C1: select * from t order by 1;
C1: commit;          

C2: quit;
C1: quit;
C3: quit;
