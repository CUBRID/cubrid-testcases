/*
Test Case: cbrd_27034_x10_forupdate_after_delete
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A SELECT ... FOR UPDATE of a row being deleted waits for the deleter and does not return the row once the delete commits.

NUM_CLIENTS = 2
C1: DELETE FROM t27034_t WHERE id=2;
C2: SELECT id, v FROM t27034_t WHERE id=2 FOR UPDATE; -- blocks
C1: COMMIT;
C2: (released)
C2: SELECT COUNT(*) FROM t27034_t;
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
C1: INSERT INTO t27034_t VALUES (1,10),(2,20),(3,30);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
C2: SELECT id, v FROM t27034_t WHERE id=2 FOR UPDATE;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 2 */
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
/* expect 0 */
C2: SELECT COUNT(*) FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 10 */
C2: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
/* expect 30 */
C2: SELECT v FROM t27034_t WHERE id=3;
MC: wait until C2 ready;
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
