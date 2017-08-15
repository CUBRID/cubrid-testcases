/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
changes committed after the query started are never seen
desc index, min value changed uncommitted by others or itself

NUM_CLIENTS = 2
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1)+10,'z' from db_class a,db_class b limit 10;
C2: select min(id) from t where id>0;      -- can not see C1's insert min value
C1: select min(col) from t where col>'a';  -- can see min value inserted by itself
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id bigint,col varchar(10));
C1: create index idx on t(id desc);
C1: create index idx_col on t(col desc);
C1: insert into t values(1,'a'),(2,'b'),(3,'c'),(4,'d'),(5,'e'),(6,'m'),(3,'b');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: set @newincr=0;
C1: insert into t select (@newincr:=@newincr+1)+10,'z' from db_class a,db_class b limit 10;
MC: wait until C1 ready;

C2: select min(id) from t where id>0;
MC: wait until C2 ready;

C1: select min(col) from t where col>'a';
C1: commit;
MC: wait until C1 ready;

C2: commit;
MC: wait until C2 ready;


C2: quit;
C1: quit;
