/*
Test Case: insert & select
Priority: 1
Reference case: 
Author: Rong Xu

Test Point:
changes committed after the query started are never seen
C2: begin;C1:begin;C1:commit;C2:rollback

NUM_CLIENTS = 2
prepare(1,3,7)
C1: insert into t values(8,'abc');
C2: select t.* from (select sleep(2)) x, t where id>0 order by id; --expected only can see 1,3,7
C1: commit;
C2: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id);
C1: insert into t values(1,'aa');
C1: insert into t values(3,'bb');
C1: insert into t values(7,'cc');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(8,'abc');
C2: select t.* from t where id>0 and (select sleep(2)) = 0 order by id,2;
MC: wait until C2 ready;
C2: rollback;
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

