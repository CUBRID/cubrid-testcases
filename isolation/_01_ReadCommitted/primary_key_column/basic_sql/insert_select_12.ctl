/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the queries began
C1 begin before C2, C2 can see committed data by C1, can not see uncommitted data of C1

NUM_CLIENTS = 2
C1: insert(2);
C2: insert(4);
C1: commit work;
C1: insert(8);
C2: select * from t order by 1;
C2: commit;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;

MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: insert into t values(4,'a4');
MC: wait until C2 ready;
C1: commit work;
C1: insert into t values(8,'abc');
MC: wait until C1 ready;
C2: select * from t order by 1;
C2: commit;

C2: quit;
C1: quit;

