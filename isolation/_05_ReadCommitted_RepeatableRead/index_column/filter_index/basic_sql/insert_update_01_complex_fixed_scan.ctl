/*
Test Case: insert & update
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
there are overlap between insert and update

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

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
C1: insert into t select t.id+1,t.col||'a' from t where (select sleep(3)=0)<>0;
MC: sleep 1; 
C2: update t set id=id+1 where id=3 using index idx(+);
C2: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;
/* expected select (1,a)(2,aa) */
C3: select * from t where char_length(col)=id using index idx(+) order by 1,2 ;
C3: commit;
MC: wait until C3 ready;

C1: commit;          
MC: wait until C1 ready;

/* result should be (1,a)(2,aa)(3,aaa)(2,aa)(4,aaaa) */
C2: select * from t where char_length(col)=id using index idx(+) order by 1,2 ; 
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
C3: quit;
