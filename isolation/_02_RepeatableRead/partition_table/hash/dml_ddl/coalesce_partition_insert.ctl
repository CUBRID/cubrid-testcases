/*
Test Case: coalesce partition & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user coalesce partition, another insert values

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by hash(id) partitions 4; 
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=1000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t coalesce partition 3; 
MC: wait until C1 ready;

C2: insert into t values(1001,'1');
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;

/* expected 1001 */
C2: select count(*) from t;
/* expected 1 row */
C2: select * from t where id=1001;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

