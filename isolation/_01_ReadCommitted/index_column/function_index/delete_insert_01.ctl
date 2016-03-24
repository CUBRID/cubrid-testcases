/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/no_index_column/basic_sql/delete_insert_01.ctl 
Author: Rong Xu

Test Point:
A begin delete
                        B begin insert
                        B commit
A end delete
A commit

NUM_CLIENTS = 2
C1: delete from t where LENGTH(col)<4 and 0 = (select sleep(1));
C2: insert into t values(2,'aa'); --expected ready, and C1 can not see it
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int AUTO_INCREMENT,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: insert into t(col) values('a');
C1: insert into t(col) values('bb');
C1: insert into t(col) values('ccc');
C1: insert into t(col) values('dd');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where LENGTH(col)<4 ;
MC: wait until C1 ready;
C2: insert into t values(2,'aa'); 
MC: wait until C2 ready;

/* expected 0 row selected */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expected (2,aa) selected */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expected 1 row selected */
C2: select * from t order by 1,2;
C2: commit;

C2: quit;
C1: quit;

