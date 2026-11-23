/*
Test Case: lock_retained/failed_update_wakes_waiter_on_next_write
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
The UPDATE of C1 changes rows 1 and 2 and waits on row 3, which C3 changed. C2 updates row 1 and waits on C1. The
UPDATE of C1 fails on its lock timeout, and C1 then updates row 5: C2 goes on before C1 commits, and row 1 shows no
change of the failed UPDATE.
Before CBRD-27654 C2 waited until C1 ended.

NUM_CLIENTS = 3
C3: UPDATE t27654_t SET v = v + 1000 WHERE id = 3;
C1: set transaction lock timeout 10;
C1: UPDATE t27654_t SET v = v + 10 WHERE id <= 3; -- waits on row 3, times out
C2: UPDATE t27654_t SET v = v + 100 WHERE id = 1; -- waits on C1
C1: UPDATE t27654_t SET v = v + 1 WHERE id = 5;
C2: (goes on)
C2: COMMIT;
C3: ROLLBACK;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 3;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27654_t;
C1: CREATE TABLE t27654_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27654_t VALUES (1,0),(2,0),(3,0),(4,0),(5,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: UPDATE t27654_t SET v = v + 1000 WHERE id = 3;
MC: wait until C3 ready;
C1: set transaction lock timeout 10;
MC: wait until C1 ready;
C1: UPDATE t27654_t SET v = v + 10 WHERE id <= 3;
MC: wait until C1 blocked;
C2: UPDATE t27654_t SET v = v + 100 WHERE id = 1;
MC: wait until C2 blocked;
/* the UPDATE of C1 times out on row 3 */
MC: wait until C1 ready;
C1: UPDATE t27654_t SET v = v + 1 WHERE id = 5;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: ROLLBACK;
MC: wait until C3 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 100, 2 0, 3 0, 4 0, 5 1 */
C1: SELECT id, v FROM t27654_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27654_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
