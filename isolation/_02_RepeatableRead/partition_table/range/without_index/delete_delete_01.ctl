/*
Test Case: delete & delete
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
one user delete some rows, others delete other rows

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c limit 10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where id%2=0;
MC: wait until C1 ready;
C2: delete from t where id%2=1;
MC: wait until C1 ready;

/* expect 5000 */
C1: select count(*) from t;
C1: commit;
MC: wait until C1 ready;
/* expect 5000 */
C2: select count(*) from t;
C2: commit;
MC: wait until C2 ready;

/* expect no value */
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

