/*
Test Case: update & select
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test the visibility of uncommited data
1. Uncommitted data are never seen by other queries
2. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time, check update does not block select.

NUM_CLIENTS = 2
C1: update on table t1
C2: Select on table t1
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* preparation */
C1: drop table if exists t1;
C1: create table t1(id int, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc');insert into t1 values(9,'abc');insert into t1 values(9,'def');insert into t1 values(10,'abc');insert into t1 values(11,'gh');insert into t1 values(15,'def');
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* do not cross partitions */
C1: update t1 set col='aa' where id<10;
C1: select * from t1 where id<16 order by 1,2;
MC: wait until C1 ready;
C2: select * from t1 where id<16 order by 1,2;
MC: wait until C2 ready;
C1: commit;
C2: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C1: quit;
C2: quit;
