/*
Test Case: update 
Priority: 1
Reference case:
Author: Lily

This case is for code coverage test.
a scenario to target heap_mvcc_insert_into_page, heap_mvcc_update_relocated_record and heap_mvcc_log_modify_relocation_link functions. (by Developer) 

Test Point:
1) C1 insert some data with short length.
2) C2 update some data with lart length.

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C1: commit;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS t;
C1: create table t (id int auto_increment, s varchar(1000));
C1: insert into t(s) values ('a');
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
C1: insert into t(s) select s from t;
MC: wait until C1 ready; 
C1: insert into t(s) select s from t;
MC: wait until C1 ready; 
C1: select count(*) from t;
C1: COMMIT;
MC: wait until C1 ready;

/* test case */
C1: update t set s = space(400) where id >0; 
MC: wait until C1 ready;
C1: commit;
MC: wait until C1 ready;

C2: update t set s = space(800) where id>0; 
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

C1: update t set s = repeat('cubrid',2) where id >0;                  
MC: wait until C1 ready;
C1: commit;
MC: wait until C1 ready;

C2: update t set s = repeat('cubrid',135) where id>0;          
MC: wait until C2 ready;
C2: select count(*) from t;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
