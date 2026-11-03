/*
Test Case: odku_replace/odku_waiter_owner_reinserts_key
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
INSERT ... ON DUPLICATE KEY UPDATE waits for the owner, which deletes the row and inserts the same key again: the ODKU updates the new row.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET v=v+5 WHERE id=1;
C2: INSERT INTO t27034_t VALUES (1, 100) ON DUPLICATE KEY UPDATE v=v+1; -- blocks
C1: DELETE FROM t27034_t WHERE id=1;
C1: INSERT INTO t27034_t VALUES (1, 50);
C1: COMMIT;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+5 WHERE id=1;
MC: wait until C1 ready;
C2: INSERT INTO t27034_t VALUES (1, 100) ON DUPLICATE KEY UPDATE v=v+1;
MC: wait until C2 blocked;
C1: DELETE FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
C1: INSERT INTO t27034_t VALUES (1, 50);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 51 */
C1: SELECT v FROM t27034_t WHERE id=1;
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
