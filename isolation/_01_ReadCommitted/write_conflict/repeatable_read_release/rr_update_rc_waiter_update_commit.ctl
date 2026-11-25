/*
Test Case: repeatable_read_release/rr_update_rc_waiter_update_commit
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
A READ COMMITTED writer of a row a REPEATABLE READ transaction updated waits for that transaction to end, then
reads the committed version again and updates it.

NUM_CLIENTS = 2
C1: UPDATE t28025_t SET v=v+1 WHERE id=1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=1; -- C2 waits for C1 to end
C1: COMMIT;
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t28025_t;
C1: CREATE TABLE t28025_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t28025_t VALUES (1,0),(2,0),(3,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t28025_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
/* C2 waits for C1 to end */
C2: UPDATE t28025_t SET v=v+100 WHERE id=1;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 101, 2 0, 3 0 */
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
