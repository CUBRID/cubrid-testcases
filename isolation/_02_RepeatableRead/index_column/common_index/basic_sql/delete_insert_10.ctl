/*
Test Case: delete & insert
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/delete_insert_22.ctl 
Author: Rong Xu

Test Point:
A begin delete
                        B begin insert
                        B commit
A end delete
A commit

NUM_CLIENTS = 2
C1: delete from t where 0=(select sleep (1));
C2: insert into t values(2,'aa'); --expected ready, and C1 can not see it
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int AUTO_INCREMENT,col varchar(10));
C1: create index idx on t(id);
C1: insert into t(col) values('a');
C1: insert into t(col) values('b');
C1: insert into t(col) values('c');
C1: insert into t(col) values('d');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where id>0 and sleep(1)=0;
MC: sleep 2;
C2: insert into t values(2,'aa'); 
/* expect select 5 rows */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

/* expected 0 row selected */
C1: select * from t order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expected 1 row selected */
C2: select * from t order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

