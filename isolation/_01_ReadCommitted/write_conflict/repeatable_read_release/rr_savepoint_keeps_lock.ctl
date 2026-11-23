/*
Test Case: repeatable_read_release/rr_savepoint_keeps_lock
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652), CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
Under REPEATABLE READ an UPDATE under a user savepoint gives its row lock back at the end of the statement too: a
rollback to the savepoint sends the writers waiting on the stamp back to read.  Another transaction with a lock
timeout of 1 second waits on the MVCCID lock of the first transaction and times out naming it.
CBRD-28025 wrote this case as a control when an UPDATE under a savepoint kept its row lock to commit, so the
timeout named the row.  Since CBRD-27654 the savepoint does not keep it.  The name keeps "keeps_lock".

NUM_CLIENTS = 2
C1: SAVEPOINT sp1;
C1: UPDATE t28025_t SET v=v+1 WHERE id=1;
C2: set transaction lock timeout 1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=1; -- C2 times out on the MVCCID lock of C1
C2: ROLLBACK;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t28025_t;
C1: CREATE TABLE t28025_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t28025_t VALUES (1,0),(2,0),(3,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SAVEPOINT sp1;
MC: wait until C1 ready;
C1: UPDATE t28025_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: set transaction lock timeout 1;
MC: wait until C2 ready;
/* C2 times out on the MVCCID lock of C1 */
C2: UPDATE t28025_t SET v=v+100 WHERE id=1;
MC: wait until C2 ready;
C2: ROLLBACK;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 1, 2 0, 3 0 */
C1: SELECT id, v FROM t28025_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t28025_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
