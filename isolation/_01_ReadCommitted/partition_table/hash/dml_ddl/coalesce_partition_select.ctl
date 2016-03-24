/*
Test Case: coalesce partition & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user coalesce partition, another select values

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col char(10)) partition by hash(id) partitions 4; 
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),'a' from db_class a,db_class b,db_class c limit 1000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: alter table t coalesce partition 3; 
MC: wait until C1 ready;

/* expected 1000 */
C2: select count(*) from t;
MC: wait until C2 blocked;

C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit;

C2: quit;
C1: quit;

