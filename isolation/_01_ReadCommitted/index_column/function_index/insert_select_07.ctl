/*
Test Case: insert & select
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/primary_key_column/basic_sql/insert_select_18.ctl
Author: Rong Xu

Test Point:
changes committed after the query started are never seen

NUM_CLIENTS = 2
C1: select t.* from (select sleep(1)) x, t where LENGTH(col)>1 order by col; -- can not see (2,abc)
C2: insert into t values(2,'abc');
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10));
C1: create index idx on t(LENGTH(col));
C1: insert into t values(1,'aa');
C1: insert into t values(3,'bbb');
C1: insert into t values(7,'cc');
C1: commit;
MC: wait until C1 ready;

/* test case */
/* can not see (2,abc) */
C1: select t.* from (select sleep(1)) x, t where LENGTH(col)>1 order by col;
C2: insert into t values(2,'abc');
C2: commit work;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: quit;
C1: quit;

