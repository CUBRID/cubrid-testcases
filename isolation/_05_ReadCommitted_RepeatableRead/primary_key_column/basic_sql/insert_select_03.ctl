/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
changes committed after the transaction started are never seen
insert into ... select ... from ...
use index in where clause
there is lock conflict

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
C1: insert into t values(1,'aa');
C1: insert into t values(3,'bb');
C1: insert into t values(7,'cc');
C1: commit;
MC: wait until C1 ready;

/* test case */
/* C1 begin before C2, but commit when C2 is not finished */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: select * from t order by col; --expected only can see 1,3,7
MC: wait until C2 ready;
C1: commit;
/* C1 insert and commit before C2 insert...select */
C1: insert into t values(5,'abc');
C1: commit;
/* C1 insert and uncommit before C2 insert...select */
C1: insert into t values(4,'abc');
MC: wait until C1 ready;
C2: insert into t select id+1,col from t where id>0; --not wait lock(identical with oracle),expected only insert 1+1,3+1,7+1
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* should be 1,3,7,2,4,5 */
C2: select * from t order by 1,2;
C2: commit;

/* should be 1,3,7,2,4,5 */
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

