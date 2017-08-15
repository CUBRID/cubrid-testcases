/*
Test Case: update & savepoint & rollback
Priority: 1
Reference case:
Author: Tonny

Test Point:
C1 update and savepoint, C2 update.
Check C1 should block C2.After C1 commit, C2 will be failed by unique constraint.

NUM_CLIENTS = 2
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=11 where id=1;
C1: savepoint sp1;
C1: update t set id=12 where id=11;
MC: wait until C1 ready;
C2: insert into t values(11,'abc');
MC: wait until C2 blocked;

/* expect (11,'abc') */
C1: select * from t order by 1,2;
C1: rollback work to sp1;


C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit;

/* expect (11,'abc') */
C2: select * from t order by 1,2;
MC: wait until C2 ready;

C2: quit;
C1: quit;
