/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
changes committed after the query started are never seen
  A begin update
                   B begin insert
                   B commit
  A update end
  A commit

NUM_CLIENTS = 2
prepare (1,2,7)
C1: update t set col='b' where id>0;
C2: insert into t values(4,'abc'); --expected no block, and not be updated
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10) unique);
C1: insert into t values(1,'a');
C1: insert into t values(2,'aa');
C1: insert into t values(7,'aaa');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set col=concat(col,'b') where sleep(1)=0 and id>0;
C2: insert into t values(4,'abc');
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: commit;          
MC: wait until C1 ready;

C2: commit;          
/* result should be (1,a)(2,a)(7,a)(4,abc) */
C2: select * from t order by 1; 
C2: commit;

C2: quit;
C1: quit;

