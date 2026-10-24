/*
Test Case: odku_replace/replace_waiter_owner_moves_key
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
REPLACE waits for the owner of the duplicate row, which moves the row to another key and commits: the REPLACE inserts the key anew and does not delete the moved row.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET k=15 WHERE id=1;
C2: REPLACE INTO t27034_t VALUES (1, 100); -- blocks
C1: UPDATE t27034_t SET id=5 WHERE id=1;
C1: COMMIT;
C2: (released)
C1: UPDATE t27034_t SET k=k+1 WHERE id=5;
C1: COMMIT;
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
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT);
C1: INSERT INTO t27034_t VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET k=15 WHERE id=1;
MC: wait until C1 ready;
C2: REPLACE INTO t27034_t VALUES (1, 100);
MC: wait until C2 blocked;
C1: UPDATE t27034_t SET id=5 WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C1: UPDATE t27034_t SET k=k+1 WHERE id=5;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 100 */
C1: SELECT k FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 16 */
C1: SELECT k FROM t27034_t WHERE id=5;
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
