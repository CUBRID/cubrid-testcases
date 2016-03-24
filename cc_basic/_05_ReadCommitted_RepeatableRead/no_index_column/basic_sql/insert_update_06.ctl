/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Lily

Test Point:
changes committed after the query started are never seen
  A begin insert
                   B begin update which satisfy A
                   B commit
  A update end
  A commit

NUM_CLIENTS = 2
prepare (1,2,7)
C1: insert into t select rownum,'b' from t where sleep(1,id)=1 where rownum <= 3;
C2: update t set col='c' where sleep(1,id)=1 and id>0;
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(1,'a');
C1: insert into t values(2,'a');
C1: insert into t values(7,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum,'b' from t where rownum <= 3;
MC: wait until C1 ready; 
C2: update t set col='c' where id>0;
MC: wait until C2 ready;
C1: commit; 
MC: wait until C1 ready;
C2: select * from t order by id;         
C2: commit;          
/* result should be (1,b)(2,b)(3,b)(1,c)(2,c)(7,c) */
C2: select * from t order by 1,2; 
C2: commit;

C2: quit;
C1: quit;

