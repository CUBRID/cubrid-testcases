/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
visability
queries can only have a look at data committed before the queries began

NUM_CLIENTS = 2
C1: insert into t values(7,'abc');
C2: select * from t order by 1;               -- no rows selected
C1: commit work;
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: delete from t where id=7;  --1 rows deleted
C2: delete from t;             --0 row deleted
C1: rollback
C2: rollback
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: insert into t values(7,'abc');
MC: wait until C1 ready;
C2: select * from t order by 1;
MC: wait until C2 ready;
C1: commit work;
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: delete from t where id=7;
C2: delete from t;
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

