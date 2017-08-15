/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data or changes committed after the query started are never seen
B begin insert
                   A begin select
                   B commit
A end select
A commit

NUM_CLIENTS = 2
C1: insert into t values(1,1);
C2: select t.* from (select sleep(1)) x, t where col=1 using index idx_id(+) order by 1,2; --expected can not select C1 inserted data
MC: sleep 1;
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col int);
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1),(@newincr)%100 from db_class a,db_class b limit 500;
C1: create index idx_id on t(col) where col=1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1,1);
MC: wait until C1 ready;

C2: select t.* from (select sleep(3)) x, t where col=1 using index idx_id(+) order by 1,2;
MC: sleep 2;
C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
