/*
Test Case: update & delete
Priority: 2
Reference case: cc_basic/_01_ReadCommitted/partition_table/range/with_index/primary_key/update_delete_01.ctl
Author: Rong Xu
Test Point:
one user update failed without commit, others can delete it

NUM_CLIENTS = 2
C1: update t set id=1000 where id=1; -- no proper partition
C2: delete from t where id=1;    -- expected no block
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int,col varchar(10)) partition by range(id)(partition p1 values less than (10),partition p2 values less than (100));
C1: insert into t values(1,'abc');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t set id=1000 where id=1;
MC: wait until C1 ready;

C2: delete from t where id=1;
MC: wait until C2 blocked;

C1: commit;
MC: wait until C1 ready;
MC: wait until C2 ready;

C2: commit;
C2: select * from t order by 1;
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;

