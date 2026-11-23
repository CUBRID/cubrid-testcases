/*
Test Case: lock_retained/failed_delete_frees_row
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
A DELETE that fails on a foreign key (ON DELETE RESTRICT) after it deleted other rows gives back the row locks it
took once its change is undone. Another transaction updates one of those rows at once, while the first transaction
is still open.
Before CBRD-27654 the failed statement kept the row locks to commit, so the UPDATE waited until the first
transaction ended.

NUM_CLIENTS = 2
C1: DELETE FROM t27654_p; -- fails on the child of row 3
C2: UPDATE t27654_p SET v = v + 10 WHERE id = 1; -- does not wait
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
C1: DROP TABLE IF EXISTS t27654_c;
C1: DROP TABLE IF EXISTS t27654_p;
C1: CREATE TABLE t27654_p (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27654_p VALUES (1,0),(2,0),(3,0);
C1: CREATE TABLE t27654_c (id INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27654_p (id) ON DELETE RESTRICT);
C1: INSERT INTO t27654_c VALUES (1,3);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27654_p;
MC: wait until C1 ready;
C2: UPDATE t27654_p SET v = v + 10 WHERE id = 1;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 10, 2 0, 3 0 */
C1: SELECT id, v FROM t27654_p ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27654_c;
C1: DROP TABLE t27654_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
