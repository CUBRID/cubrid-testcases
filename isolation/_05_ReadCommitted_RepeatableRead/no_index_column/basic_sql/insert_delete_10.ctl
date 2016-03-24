/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Lily

Test Point:
changes committed after the transaction started are never seen
  A begin insert
                   B begin delete which satisfy A
                   B commit
  A insert end
  A commit

NUM_CLIENTS = 2
prepare (5,6,7)
C1: insert into t select rownum,'b' from t where sleep(1,id)=1 where rownum <= 3;
C2: delete from t where id>0 and sleep(1,id);
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(5,'a');
C1: insert into t values(6,'a');
C1: insert into t values(7,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum,'b' from t where rownum <= 3; 
MC: wait until C1 ready;
C2: delete from t where id>0;
MC: wait until C2 ready;
MC: sleep 2;
C2: commit;          
MC: wait until C2 ready;
C1: commit;          
MC: wait until C1 ready;
/* result should be (1,b)(2,b)(3,b) */
C2: select * from t order by 1,2; 
C2: commit;

C2: quit;
C1: quit;

