/*
Test Case: delete & insert
Priority: 
Reference case: 
Author: Rong Xu

Test Point:
there is overlap between insert and delete

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: insert into t(id,col) values(1,'a');
C1: insert into t(id,col) values(2,'bb');
C1: insert into t(id,col) values(3,'ccc');
C1: insert into t(id,col) values(4,'dd');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where LENGTH(col)<4;
MC: wait until C1 ready;
C2: insert into t values(2,'aa');
MC: wait until C2 ready;

/* expected (2,aa)(1,a)(2,bb)(3,ccc)(4,dd) */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expected 0 row selected */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

