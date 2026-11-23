/*
Test Case: lock_retained/failed_update_frees_row
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
An UPDATE that fails on a unique key gives back the row lock it took once its change is undone. Another transaction
updates the same row at once, while the first transaction is still open.
Before CBRD-27654 the failed statement kept the row lock to commit, so the second UPDATE waited until the first
transaction ended.

NUM_CLIENTS = 2
C1: UPDATE t27654_u SET v = 3 WHERE id = 1; -- fails on the unique key
C2: UPDATE t27654_u SET v = v + 10 WHERE id = 1; -- does not wait
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
C1: DROP TABLE IF EXISTS t27654_u;
C1: CREATE TABLE t27654_u (id INT PRIMARY KEY, v INT UNIQUE);
C1: INSERT INTO t27654_u VALUES (1,1),(2,2),(3,3);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27654_u SET v = 3 WHERE id = 1;
MC: wait until C1 ready;
C2: UPDATE t27654_u SET v = v + 10 WHERE id = 1;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 11, 2 2, 3 3 */
C1: SELECT id, v FROM t27654_u ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27654_u;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
