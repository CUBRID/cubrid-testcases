/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_01.ctl
Author: Lily

Test Point:
Reading queries can only have a look at data committed before the transaction began
one user insert uncommitted, another user select all rows

NUM_CLIENTS = 2
C1: insert(2);
C2: select * from t order by 1; --2 is invisable
C1: commit
C2: commit
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: insert into t values(1,'abc');
C1: insert into t values(3,'abc');
C1: insert into t values(7,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(2,'abc');
MC: wait until C1 ready;
C2: insert into t values(4,'a4');
C2: select * from t order by 1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select * from t order by 1;
C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C1 ready;
C1: commit;
C2: quit;
C1: quit;

