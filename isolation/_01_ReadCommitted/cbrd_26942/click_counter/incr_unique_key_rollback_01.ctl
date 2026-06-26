/*
Test Case: click-counter (INCR) on a unique key via select-update sub-transaction
Reference case: CBRD-26942
Function: INCR/DECR

Test Point:
Coverage for the click-counter (INCR/DECR) self-lock path on CBRD-26942.
A click-counter increment in a SELECT runs in an autonomous select-update
sub-transaction; when it targets a UNIQUE key it performs an MVCC key change
(old key removed, new key inserted INSERT_IN_PROGRESS) stamped with the
sub-transaction MVCCID, and must take/release the inserter self-lock under
that same sub-MVCCID. This exercises that acquire+release on a unique index.

Note: the sub-transaction auto-commits at statement end, so this is not a
deterministic "blocked" test; it is a deterministic functional guard that the
increment (1) persists across the outer rollback (autonomous), (2) frees the
old unique key for reuse, and (3) commits the new unique key so it is enforced.

NUM_CLIENTS = 3
C1 SELECT INCR(a) on the row a=1  -> autonomous sub-tx moves unique key 1 -> 2
C1 rollback                       -> outer tx rolls back; click increment persists
C2 INSERT a=1                     -> freed key, succeeds
C2 INSERT a=2                     -> committed key, unique violation
C3 verify final state {1,2,5}

*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists tb;
C1: create table tb(a int, cnt int, constraint uq_tb_a unique(a));
C1: insert into tb values(1,0),(5,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: select a, incr(a) from tb where a=1;
MC: wait until C1 ready;
C1: rollback;
MC: wait until C1 ready;

/* committed state now: (2,0),(5,0) - increment persisted across outer rollback */
C2: insert into tb values(1,100);
C2: insert into tb values(2,200);
C2: commit;
MC: wait until C2 ready;

/* expected final: (1,100),(2,0),(5,0); second C2 insert rejected by unique violation */
C3: select * from tb order by 1,2;
C3: commit;

C3: quit;
C2: quit;
C1: quit;
