/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_20.ctl
Author: Rong Xu

Test Point:
insert into ... select ... from ...
A begin insert into select ...
                        B begin insert which satisfy select
                        B commit
A end insert
A commit

NUM_CLIENTS = 2
C1: insert into t(id, col) select id+4, col from (select sleep(1)) x, t where id>0;
C2: insert into t values(20,'b'); --expected ready, and not insert twice
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int, col varchar(10));
C1: create unique index idx on t(id) with online parallel 7;
C1: insert into t(id, col) values(1,'b');
C1: insert into t(id, col) values(2,'b');
C1: insert into t(id, col) values(3,'b');
C1: insert into t(id, col) values(4,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t(id, col) select id+4, col from t where id>0 and (select sleep(1)) = 0;
C2: insert into t values(20,'b');
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected only one row*/
C1: select * from t where id=20 order by 1,2;
MC: wait until C1 ready;

C2: commit;          
MC: wait until C2 ready;

C1: commit;
C2: quit;
C1: quit;

