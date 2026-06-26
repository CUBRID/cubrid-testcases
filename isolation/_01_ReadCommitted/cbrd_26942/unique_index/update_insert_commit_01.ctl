/*
Test Case: update & insert (unique index, UPDATE-path inserter self-lock)
Reference case: CBRD-26942

Test Point:
Regression guard for the UPDATE-path inserter self-lock gap (CBRD-26942).
Commit branch of the wait+resume: a concurrent INSERT of the same unique
value waits on the in-progress key produced by an MVCC UPDATE; once the
updater commits, the resumed INSERT must observe the now-committed key and
fail with a unique violation.

NUM_CLIENTS = 2
C1 UPDATE changes unique key 1 -> 2 (new key 2 is INSERT_IN_PROGRESS)
C2 INSERT the same unique value 2 --expected hang here (waits on C1 self-lock)
C1 commit    (key 2 committed, row is now 2)
C2 ready -> INSERT fails with unique violation; final unique set {2}

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
C1: commit;
MC: wait until C2 ready;
C2: commit;

/* expected t1: only (2,'a') from C1; C2 insert rejected by unique violation */
C2: select * from t1 order by 1,2;
C2: commit;

C2: quit;
C1: quit;
