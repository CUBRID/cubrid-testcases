/*
Test Case: insert & select
Priority: 1
Reference case:
Author: Rong Xu

Test Point:
Reading queries can only have a look at data committed before the transaction began
C1 begin before C2, C2 can not see committed/rollback/uncommitted data by C1

NUM_CLIENTS = 4
C1: insert(2);
C2: insert(4);
C3: insert(2); -- expected blocked
C4: insert(5);
C1: commit work;
C1: insert(8);
C2: commit;
C3: commit;
C4: commit;
C2: select * from t where id>0 order by 1;
C2: commit;
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;

C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;
/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(id desc);
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
C3: insert into t values(2,'abc');
MC: wait until C3 ready;
C4: insert into t values(5,'a5');
MC: wait until C4 ready;
C1: insert into t values(6,'abc');
C1: insert into t values(8,'abc');
C1: commit work;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;

/* expected (1,abc)(3,abc)(7,abc)(4,a4) */
C2: select * from t where id<10 order by 1;
C2: commit;

C1: quit;
C2: quit;
C3: quit;
C4: quit;

