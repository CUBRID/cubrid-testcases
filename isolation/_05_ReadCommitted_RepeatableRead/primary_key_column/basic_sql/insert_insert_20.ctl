/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
insert into ... select ... from ...
A begin insert into select ...
                        B begin insert which satisfy select
                        B commit
A end insert
A commit

NUM_CLIENTS = 2
C1: insert into t(col) select col from (select sleep(1)) x, t;
C2: insert into t values(20,'b'); --expected ready, and not insert twice
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t(id,col) values(1,'b');
C1: insert into t(id,col) values(2,'b');
C1: insert into t(id,col) values(3,'b');
C1: insert into t(id,col) values(4,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expect id value (1,2,3,4) */
C2: select * from t order by id;
MC: wait until C2 ready;
C1: insert into t(id,col) select id+4,col from t where (select sleep(5)) = 0;
MC: wait until C1 ready;
C2: insert into t values(7,'b');
MC: wait until C2 blocked;
C1: commit;
/* expect id value (1,2,3,4), a unique key violation error */
MC: wait until C2 ready;
C2: select * from t order by id;
MC: wait until C2 ready;
C2: commit;
/* expected id value (1-8) */
C2: select * from t order by id;
MC: wait until C1 ready;
C2: commit;          

C1: commit;
C2: quit;
C1: quit;

