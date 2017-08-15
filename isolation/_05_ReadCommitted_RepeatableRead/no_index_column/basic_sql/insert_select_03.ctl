/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_11.ctl
Author: Lily

Test Point:
The only visible uncommitted data are the effects of current transaction updates
insert many rows, select by himself, rollback, then select by himself

NUM_CLIENTS = 2
C1: insert(2);
C1: insert(9);
C1: insert(10);
C1: insert(21);
C1: insert(22);
C1: select * from t order by 1; -- all data are visable
C1: rollback work;
C1: select * from t order by 1; -- above data are invisable
C2: select * from t order by 1;
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
C1: insert into t values(9,'abc');
C1: insert into t values(10,'abc');
C1: insert into t values(21,'abc');
C1: insert into t values(22,'abc');
C1: select * from t order by 1;
MC: sleep 3;
C1: rollback work;
C1: select * from t order by 1;
MC: wait until C1 ready;
C2: select * from t order by 1;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
C1: quit;
C2: quit;

