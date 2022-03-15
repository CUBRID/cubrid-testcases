/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
A select begin
  B update begin which satisfy A, update to a value did not satisfy filter condition
    C insert a value which satisfy A
    C commit
  B commit
A select end

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(100));
C1: create index idx on t(id) where char_length(col)=id;
C1: insert into t values(1,'a');
C1: insert into t values(2,'aa');
C1: insert into t values(3,'aaa');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expected select (1,a)(2,aa)(3,aaa) */
C1: select t.* from t where char_length(col)=id and sleep(1)=0 using index idx(+);
C3: update t set id=id+1 where id=2;
C3: commit;
MC: wait until C3 ready;
C2: insert into t values(3,'aaa'); 
C2: commit;          
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: commit;          
MC: wait until C1 ready;

/* result should be (1,a)(3,aa)(3,aaa)(3,aaa) */
C2: select * from t order by 1,2;
/* result should be (1,a)(3,aaa)(3,aaa) */
C2: select * from t where char_length(col)=id using index idx(+); 
C2: commit;

C2: quit;
C1: quit;
C3: quit;
