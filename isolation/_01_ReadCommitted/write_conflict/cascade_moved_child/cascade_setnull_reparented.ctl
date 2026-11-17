/*
Test Case: cascade_moved_child/cascade_setnull_reparented
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The same as cascade_child_reparented under ON DELETE SET NULL: the moved child keeps its new parent and is not nulled.

NUM_CLIENTS = 2
C1: UPDATE t27464_chi SET pid=2 WHERE id=11;
C2: DELETE FROM t27464_par WHERE id=1;
C1: COMMIT;
C2: SELECT id, pid FROM t27464_chi ORDER BY id;
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_chi;
C1: DROP TABLE IF EXISTS t27464_par;
C1: CREATE TABLE t27464_par (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t27464_chi (id INT PRIMARY KEY, pid INT, w INT, FOREIGN KEY (pid) REFERENCES t27464_par(id) ON DELETE SET NULL);
C1: INSERT INTO t27464_par VALUES (1,10),(2,20);
C1: INSERT INTO t27464_chi VALUES (10,1,0),(11,1,0),(20,2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27464_chi SET pid=2 WHERE id=11;
MC: wait until C1 ready;
C2: DELETE FROM t27464_par WHERE id=1;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, pid FROM t27464_chi ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C2: SELECT COUNT(*) FROM t27464_par;
MC: wait until C2 ready;
/* expect 3 */
C2: SELECT COUNT(*) FROM t27464_chi;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27464_chi WHERE pid IS NULL;
MC: wait until C2 ready;
/* expect 2 */
C2: SELECT pid FROM t27464_chi WHERE id=11;
MC: wait until C2 ready;
/* expect 2 */
C2: SELECT pid FROM t27464_chi WHERE id=20;
MC: wait until C2 ready;
/* expect 2 */
C2: SELECT COUNT(*) FROM t27464_chi WHERE pid=2;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_chi;
C1: DROP TABLE t27464_par;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
