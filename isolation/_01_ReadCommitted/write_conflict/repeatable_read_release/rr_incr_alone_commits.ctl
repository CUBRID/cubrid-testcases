/*
Test Case: repeatable_read_release/rr_incr_alone_commits
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
Control: under REPEATABLE READ an INCR of a row the transaction did not change commits on its own.  Another
transaction updates the row and commits while the first transaction is still open.

NUM_CLIENTS = 2
C1: SELECT INCR(v) FROM t28025_t WHERE id=2; -- the increment commits on its own
C2: set transaction lock timeout 1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=2; -- C2 updates the row
C2: COMMIT;
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
/* the increment commits on its own */
C1: SELECT INCR(v) FROM t28025_t WHERE id=2;
MC: wait until C1 ready;
C2: set transaction lock timeout 1;
MC: wait until C2 ready;
/* C2 updates the row */
C2: UPDATE t28025_t SET v=v+100 WHERE id=2;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 0, 2 101, 3 0 */
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
