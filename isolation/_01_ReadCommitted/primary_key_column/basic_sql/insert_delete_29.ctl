/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
insert into ... select ... from ...
A begin insert into select ...
                        B begin delete which satisfy select
                        B commit
A end insert
A commit

NUM_CLIENTS = 2
C1: insert into t(col) select col from t where sleep(1)=0 order by id;
C2: delete from t where id=3; --expected ready, and insert by C1
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key AUTO_INCREMENT,col varchar(10));
C1: insert into t(col) values('a');
C1: insert into t(col) values('b');
C1: insert into t(col) values('c');
C1: insert into t(col) values('d');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t(col) select col from t, (select sleep(4)) x order by id,col;
C2: delete from t where id=3;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected one row selected */
C1: select * from t where col='c' order by 1,2;
MC: wait until C1 ready;

C2: commit;          

C2: quit;
C1: quit;

