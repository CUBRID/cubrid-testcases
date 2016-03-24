/*
Test Case: insert & update
Priority: 1 
Reference case: 
Author: Rong Xu
Test Point:
A  update
B  insert a value conflict with new updated value
A commit
B commit

NUM_CLIENTS = 2
C1: update t set col='def' where id >0;
MC: wait until C1 ready;
C2: insert into t values('3','def'); --expected blocked
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create unique index idx on t(id,col);
C1: insert into t values(1,'a');
C1: insert into t values(2,'b');
C1: insert into t values(3,'c');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col='def' where id >0;
MC: wait until C1 ready;

C2: insert into t values('3','def');
MC: wait until C2 blocked;

C1: rollback;
MC: wait until C1 ready;

/* expected c2 success */
C2: commit;

C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

