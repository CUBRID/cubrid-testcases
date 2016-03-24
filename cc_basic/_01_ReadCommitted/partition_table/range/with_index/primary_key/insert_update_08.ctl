/*
Test Case: insert & update
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
update many rows and rollback,another insert

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: drop table if exists t1;
C1: create table t(id int,col int ,primary key(id, col)) partition by range(id)(partition p1 values less than (10),partition p2 values less than MAXVALUE);
C1: create table t1(id int);
C1: insert into t1 values(1),(2),(3),(4),(5),(6),(7),(8),(9),(10);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)*2-1 from t1 a,t1 b,t1 c,t1 d,t1 e,t1 f limit 1000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=id+1,col=col+1;
MC: sleep 1;
C2: insert into t values(1,1);
MC: wait until C2 blocked;

C1: rollback;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit work;
/* expected 1000 */
C2: select count(*) from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

