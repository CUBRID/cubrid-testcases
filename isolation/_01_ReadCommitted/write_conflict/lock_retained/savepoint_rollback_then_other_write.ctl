/*
Test Case: lock_retained/savepoint_rollback_then_other_write
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
C2 waits for a row that C1 updated under a savepoint. C1 rolls back to the savepoint and updates another row: C2
goes on before C1 commits, and applies its update on the original value.
Before CBRD-27654 C2 waited until C1 ended. When C1 writes nothing after the rollback, C2 still waits until C1 ends:
savepoint_rollback.

NUM_CLIENTS = 2
C1: SAVEPOINT sp1;
C1: UPDATE t27654_t SET v = v + 1 WHERE id = 1;
C2: UPDATE t27654_t SET v = v + 10 WHERE id = 1; -- waits on C1
C1: ROLLBACK TO SAVEPOINT sp1;
C1: UPDATE t27654_t SET v = v + 1 WHERE id = 3;
C2: (goes on)
C2: COMMIT;
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
C1: DROP TABLE IF EXISTS t27654_t;
C1: CREATE TABLE t27654_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27654_t VALUES (1,0),(2,0),(3,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SAVEPOINT sp1;
MC: wait until C1 ready;
C1: UPDATE t27654_t SET v = v + 1 WHERE id = 1;
MC: wait until C1 ready;
C2: UPDATE t27654_t SET v = v + 10 WHERE id = 1;
MC: wait until C2 blocked;
C1: ROLLBACK TO SAVEPOINT sp1;
MC: wait until C1 ready;
C1: UPDATE t27654_t SET v = v + 1 WHERE id = 3;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 10, 2 0, 3 1 */
C1: SELECT id, v FROM t27654_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27654_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
