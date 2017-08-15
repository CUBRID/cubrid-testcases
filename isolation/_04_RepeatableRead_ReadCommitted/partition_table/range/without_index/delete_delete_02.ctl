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

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10000),partition p2 values less than MAXVALUE);
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum <= 10000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t where mod(id,2)=0;
MC: sleep 1;
C2: delete from t;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: commit;

C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

