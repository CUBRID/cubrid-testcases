/*
Test Case: update & insert (unique index, UPDATE-path inserter self-lock)
Reference case: CBRD-26942

Test Point:
Regression guard for the UPDATE-path inserter self-lock gap (CBRD-26942).
An MVCC UPDATE that changes a UNIQUE key value must take the inserter
self-lock (keyed by the inserter MVCCID) on the new INSERT_IN_PROGRESS key,
exactly as a plain INSERT does. Otherwise a concurrent INSERT of the same
unique value would not serialize against the in-progress key.

NUM_CLIENTS = 2
C1 UPDATE changes unique key 1 -> 2 (new key 2 is INSERT_IN_PROGRESS)
C2 INSERT the same unique value 2 --expected hang here (waits on C1 self-lock)
C1 rollback   (key 2 never committed, row reverts to 1)
C2 ready -> INSERT succeeds; final unique set {1, 2}

*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1;
C1: create table t1(a int, b varchar(10), constraint uq_t1_a unique(a));
C1: insert into t1 values(1,'a');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: update t1 set a=2 where a=1;
MC: wait until C1 ready;
C2: insert into t1 values(2,'mm');
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: commit;

/* expected t1: (1,'a') reverted by C1 rollback, (2,'mm') inserted by C2 */
C2: select * from t1 order by 1,2;
C2: commit;

C2: quit;
C1: quit;
