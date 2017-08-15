/*
Test Case: insert & insert
Priority: 1
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_insert_20.ctl
Author: Lily

Test Point:
insert into ... select ... from ...
A begin insert into select ...
                        B begin insert which satisfy select
                        B commit
A end insert
A commit

NUM_CLIENTS = 2
C1: insert into t(col) select * from t where sleep(1,col)=1;
C2: insert into t values(20,'b'); --expected ready, and not insert twice
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int AUTO_INCREMENT,col varchar(10));
C1: insert into t(col) values('b');
C1: insert into t(col) values('b');
C1: insert into t(col) values('b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t(col) select col from (select sleep(1)) x, t;
C2: insert into t values(20,'b');
MC: wait until C2 ready;
C2: commit;
MC: wait until C1 ready;
MC: sleep 4;
C1: insert into t(col) select col from t where id=20;
C1: commit;
MC: wait until C1 ready;
/* expected only one row*/
C1: select * from t where id=20;
C1: commit;          

C2: quit;
C1: quit;

