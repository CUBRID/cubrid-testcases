/*
Test Case: coalesce partition & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
there are many unvacuumed version, then do coalesce

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint,col char(10)) partition by hash(id) partitions 4; 
C1: commit work;
MC: wait until C1 ready;
C1: insert into t select rownum,'a' from db_class a,db_class b,db_class c where rownum<=10000;
C1: update t set id=id+1;
C1: update t set id=id-1;
C1: update t set id=id+1;
C1: update t set id=id-1;
C1: update t set id=id+1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: select sum(id) from t;
C2: update t set id=id-1;
C2: alter table t coalesce partition 2; 
C2: savepoint p1;
C2: alter table t coalesce partition 1; 

C2: rollback to p1;

/* expect 50005000 */
C2: select sum(id) from t;
C2: commit;

/* expect 50005000 */
C2: select sum(id) from t;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

