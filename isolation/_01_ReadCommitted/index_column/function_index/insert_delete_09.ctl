/*
Test Case: insert & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_delete_29.ctl
Author: Rong Xu

Test Point:
insert into ... select ... from ...
A begin insert into select ...
                        B begin delete which satisfy select
                        B commit
A end insert
A commit

NUM_CLIENTS = 2
C1: insert into t(col) select col from (select sleep(1)) x, t where LENGTH(col)>0 order by id;
C2: delete from t where id=3; --expected ready, and C1 can see 3
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int AUTO_INCREMENT,col varchar(10));
C1: insert into t(col) values('a');
C1: insert into t(col) values('b');
C1: insert into t(col) values('cc');
C1: insert into t(col) values('ddd');
C1: create index idx on t(LENGTH(col));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t(col) select col from t where LENGTH(col)>0 and sleep(1)=0 order by id;
C2: delete from t where id=3;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

/* expected (1,a)(2,b)(4,ddd) (5,a)(6,b)(7,cc)(8,ddd) */
C1: select * from t where LENGTH(col)>0 order by id;
C1: commit;

C2: quit;
C1: quit;

