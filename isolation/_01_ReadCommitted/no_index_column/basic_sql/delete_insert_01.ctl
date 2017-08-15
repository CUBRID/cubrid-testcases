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
C1: delete from t where sleep(1)=0;
C2: insert into t values(2,'aa'); --expected ready, and C1 can not see it
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
C1: delete from t where id<=4 and sleep(1)=0;
MC: sleep 1;
C2: insert into t values(0,'aa'); 
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
/* expected (0,aa) */
C1: select * from t order by 1,2;
MC: wait until C1 ready;

/* expected 5 row selected */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;
C1: commit;

C1: select * from t order by 1,2;
C1: commit;

C2: quit;
C1: quit;

