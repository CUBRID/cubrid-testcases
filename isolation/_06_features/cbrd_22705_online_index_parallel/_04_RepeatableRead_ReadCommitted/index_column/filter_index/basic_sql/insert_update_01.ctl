/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
A insert ... select ... begin
  B update begin
    C select begin
    C commit
  B commit
A commit

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(100));
C1: create index idx on t(id) where char_length(col)=id with online parallel 3;
C1: insert into t values(1,'a');
C1: insert into t values(2,'aa');
C1: insert into t values(3,'aaa');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t select t.* from t where 0=(select sleep(1)); 
MC: wait until C1 ready;

C2: update t set id=id+1 where id=3;
MC: wait until C2 ready;

/* expected select (1,a)(2,aa)(3,aaa) */
C3: select * from t where char_length(col)=id using index idx(+) order by 1,2;
MC: wait until C3 ready;

C3: commit;
MC: wait until C3 ready;

C1: commit;          
MC: wait until C1 ready;

C2: commit;          
/* result should be (1,a)(2,aa)(3,aaa) */
C2: select * from t where char_length(col)=id using index idx(+) order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
C3: quit;
