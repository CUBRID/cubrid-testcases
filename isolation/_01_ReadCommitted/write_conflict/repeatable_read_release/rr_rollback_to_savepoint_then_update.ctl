/*
Test Case: repeatable_read_release/rr_rollback_to_savepoint_then_update
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
Control: under REPEATABLE READ a transaction updates a row under a savepoint, rolls back to the savepoint, updates
another row and commits.  Only the second change stays.

NUM_CLIENTS = 1
C1: SAVEPOINT sp1;
C1: UPDATE t28025_t SET v=v+1 WHERE id=1;
C1: ROLLBACK TO SAVEPOINT sp1;
C1: UPDATE t28025_t SET v=v+5 WHERE id=2;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

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
C1: ROLLBACK TO SAVEPOINT sp1;
MC: wait until C1 ready;
C1: UPDATE t28025_t SET v=v+5 WHERE id=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 0, 2 5, 3 0 */
C1: SELECT id, v FROM t28025_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t28025_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
