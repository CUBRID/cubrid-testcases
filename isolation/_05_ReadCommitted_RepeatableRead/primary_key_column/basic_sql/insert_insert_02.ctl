/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
C1: select 1 ... 10
C2: insert 5 and commit -- insert value among 1 to 10
C1: insert 5   --expected failed

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(10,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select * from t order by 1;
MC: wait until C2 ready;
C1: insert into t values(5,'a');
C1: commit;

/* expect insert failed */
C2: insert into t values(5,'b');
/* expected 1,10 */
C2: select * from t order by 1;
C2: commit work;
/* expected 1,10,5 */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

