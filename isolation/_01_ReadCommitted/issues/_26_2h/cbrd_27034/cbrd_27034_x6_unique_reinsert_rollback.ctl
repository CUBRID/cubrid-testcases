/*
Test Case: cbrd_27034_x6_unique_reinsert_rollback
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
An INSERT of a primary key being deleted waits, and fails with a unique violation once the delete rolls back.

NUM_CLIENTS = 2
C1: DELETE FROM t27034_t WHERE id=2;
C2: INSERT INTO t27034_t VALUES (2, 222); -- blocks
C1: ROLLBACK;
C2: (released, fails)
C2: SELECT id, v FROM t27034_t ORDER BY id;
C2: COMMIT;
C1: SELECT id, v FROM t27034_t ORDER BY id;
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
C1: INSERT INTO t27034_t VALUES (1,10),(2,20);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO t27034_t VALUES (2, 222);
MC: wait until C2 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, v FROM t27034_t ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: SELECT id, v FROM t27034_t ORDER BY id;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 10 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 20 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_t WHERE v=222;
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
