/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
two users insert the same value, there are no block

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than MAXVALUE);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,'a');
MC: wait until C1 ready;
C2: insert into t values(1,'a');
MC: wait until C2 ready;
C1: delete from t where id=1;
MC: wait until C1 ready;
C2: insert into t values(1,'a');
MC: wait until C2 ready;

/* expect no value */
C1: select * from t order by 1,2;
C1: commit work;
MC: wait until C1 ready;

/* expect (1,'a')(1,'a') */
C2: select * from t order by 1,2;
C2: commit work;
MC: wait until C2 ready;

/* expect (1,'a')(1,'a') */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

