/*
Test Case: lock_retained/savepoint_delete_deadlock
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A DELETE under a savepoint that is rolled back and done again keeps its row lock to commit; the waiting UPDATE updates nothing and no deadlock occurs.

NUM_CLIENTS = 2
C1: SAVEPOINT sp;
C1: DELETE FROM t27034_t WHERE id=2;
C2: UPDATE t27034_t SET v=v+1 WHERE id=2; -- blocks
C1: ROLLBACK TO SAVEPOINT sp;
C1: DELETE FROM t27034_t WHERE id=2;
C1: COMMIT;
C2: (released)
C2: COMMIT;
C1: SELECT COUNT(*) FROM t27034_t;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t VALUES (2,20);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SAVEPOINT sp;
MC: wait until C1 ready;
C1: DELETE FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=2;
MC: wait until C2 blocked;
C1: ROLLBACK TO SAVEPOINT sp;
MC: wait until C1 ready;
C1: DELETE FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
