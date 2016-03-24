/*
Test Case: delete & delete
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
one user delete some rows, others delete rows includes user1's rows

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C1: commit;
MC: wait until C1 ready;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
MC: wait until C2 ready;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where id%2=0;
MC: sleep 5;
C2: delete from t where id<10;
MC: wait until C2 blocked;

/* expect 5000 */
C1: select count(*) from t;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

/* expect 10000 */
C2: select count(*) from t;
C2: commit;
MC: wait until C2 ready;

C2: select * from t where id<10 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

