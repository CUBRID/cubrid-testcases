/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
changes committed after the query started are never seen
min value changed uncommitted by others or itself

NUM_CLIENTS = 2
C1: insert into t select rownum+10,'z' from db_class a,db_class b where rownum <= 10;
C2: select min(id) from t where id>0;      -- can not see C1's insert min value
C1: select min(col) from t where col>'a';  -- can see min value inserted by itself
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
C1: create index idx_col on t(col);
C1: insert into t values(1,'a');insert into t values(2,'b');insert into t values(3,'c');insert into t values(4,'d');insert into t values(5,'e');insert into t values(6,'m');insert into t values(3,'b');
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t select rownum+10,'z' from db_class a,db_class b where rownum <= 10;
MC: wait until C1 ready;

C1: select min(id) from t where id>0;
MC: wait until C1 ready;

C2: select min(col) from t where col>'a';
MC: wait until C2 ready;

C2: commit;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;


C2: quit;
C1: quit;
