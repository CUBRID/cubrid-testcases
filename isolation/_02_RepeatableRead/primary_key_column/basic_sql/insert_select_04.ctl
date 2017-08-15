/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
changes committed after the transaction started are never seen
use index in where clause

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'aa');
C1: insert into t values(3,'bb');
C1: insert into t values(7,'cc');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: select * from t order by 1,2; --expected only can see 1,3,7
MC: wait until C2 ready;
C1: commit;
C1: insert into t values(4,'abc');
C1: commit;
C1: insert into t values(5,'abc');
MC: wait until C1 ready;
C2: select * from t where id>0 and id<10 order by 1,2; --expected only can see 1,3,7
C2: commit;
MC: wait until C2 ready;
C1: commit;

C2: quit;
C1: quit;

