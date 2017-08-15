/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
there are lots of unvacuummed version, one user insert, another select max

NUM_CLIENTS = 2
C2: commit -- 1 row insert
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10),col1 varchar(10)) partition by range(id)(partition p1 values less than (5000),partition p2 values less than (10000));
C1: insert into t select rownum,'a','b' from db_class a,db_class b,db_class c,db_class d where rownum <= 4000;
C1: insert into t select rownum+5000,'a','b' from db_class a,db_class b,db_class c,db_class d where rownum <= 4000;
C1: commit;
C1: create unique index idx on t(id,col,col1);
C1: commit work;
MC: wait until C1 ready;

/* prepare unvacuummed data */
C1: update t set id=id+1 where id<5000;
C2: update t set id=id+1 where id>=5000;
MC: sleep 10;
C1: commit;
MC: sleep 10;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: update t set id=id+1 where id<5000;
C2: update t set id=id+1 where id>=5000;
MC: sleep 10;
C1: commit;
MC: sleep 10;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: update t set id=id+1 where id<5000;
C2: update t set id=id+1 where id>=5000;
MC: sleep 10;
C1: commit;
MC: sleep 10;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

/* test case */
C1: insert into t values(9999,'abc','a');
MC: wait until C1 ready;
/* expected 9003 */
C2: select max(id) from t where id>0;
/* expected 4003 */
C2: select max(id) from t where id<5000;
/* expected 9003 */
C2: select max(id) from t where id>5000;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
/* expected 9999 */
C2: select max(id) from t where id>0;
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;

