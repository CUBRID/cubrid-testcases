/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
two clients insert the same row at the same time, the first rollback

NUM_CLIENTS = 2
C1: insert into t values(1,'a');
C2: insert into t values(2,'a');
C1: rollback
C2: commit -- 1 row insert
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: create table t(id int,col int primary key) partition by list(col)(partition p1 values in (1,2,3,4,5), partition p2 values in (6,7,8,9,10,11)); 
C1: commit work;

/* test case */
C1: insert into t values(1,1);
MC: wait until C1 ready;
C2: insert into t values(2,1);
MC: wait until C2 blocked;
C1: rollback work;
MC: wait until C1 ready;
C2: commit work;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

