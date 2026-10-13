/*
Test Case: cbrd_27034_q4_multirow_values_vs_delete
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A three-row INSERT ... VALUES of which one row meets an uncommitted DELETE waits as a whole and inserts all three rows once the DELETE commits.

NUM_CLIENTS = 2
C1: DELETE FROM t27034_t WHERE id=2;
C2: INSERT INTO t27034_t VALUES (2,222),(4,44),(5,55); -- blocks
C1: COMMIT;
C2: (released)
C2: SELECT id, k FROM t27034_t ORDER BY id;
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
C1: INSERT INTO t27034_t VALUES (1,10),(2,20),(3,30);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO t27034_t VALUES (2,222),(4,44),(5,55);
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, k FROM t27034_t ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 5 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 222 */
C1: SELECT k FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 44 */
C1: SELECT k FROM t27034_t WHERE id=4;
MC: wait until C1 ready;
/* expect 55 */
C1: SELECT k FROM t27034_t WHERE id=5;
MC: wait until C1 ready;
/* expect 361 */
C1: SELECT SUM(k) FROM t27034_t;
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
