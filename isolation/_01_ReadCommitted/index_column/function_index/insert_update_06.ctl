/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
changes committed after the query started are never seen
  A begin insert
                   B begin update which satisfy A
                   B commit
  A insert end
  A commit

NUM_CLIENTS = 2
prepare ('a ',' a')
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(trim(col));
C1: insert into t values(1,' b ');
C1: insert into t values(2,' b');
C1: insert into t values(7,'b ');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'b' from (select sleep(1)) x, t limit 3; 
MC: wait until C1 ready;
C2: update t set col='b ' where 0 = (select sleep(1)) and trim(col)='b';
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;          
MC: wait until C2 ready;
/* result should be (1,b)(2,b)(3,b)(1,'b ')(2,'b ')(7,'b ') */
C2: select * from t where trim(col)='b' order by 1,2;
C2: commit;

C2: quit;
C1: quit;

