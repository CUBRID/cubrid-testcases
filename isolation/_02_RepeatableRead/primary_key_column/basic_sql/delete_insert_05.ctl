/*
Test Case: delete & insert
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
one user delete the whole table, another insert

NUM_CLIENTS = 2
prepare (3,7)
C1: delete * from t;
C2: insert into t values(7);  -- violate uique constraint
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t;
MC: wait until C1 ready;
/* expect blocked since X_LOCK on table t1*/
C2: insert into t values(7,'abc');
MC: wait until C2 blocked;
C1: commit work;

/* expect id value: 3,7 are still existed */
MC: wait until C2 ready;
C2: select * from t order by 1;
C2: commit;

/* expect id value: none */
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

