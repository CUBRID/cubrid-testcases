/*
Test Case: delete & delete
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
two client delete different rows

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: commit work;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10000),partition p2 values less than maxvalue);
C1: commit work;
MC: wait until C1 ready;
C1: insert into t values(1,1);
C1: insert into t values(1,1);
C1: insert into t values(1,1);
C1: insert into t values(1,1);
C1: insert into t values(2,2);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;
C1: delete from t where id>1;
MC: wait until C1 ready;
C2: delete from t where id=1;
/* expect (2,2) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;
/* (1,1),(1,1),(1,1),(1,1) */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

