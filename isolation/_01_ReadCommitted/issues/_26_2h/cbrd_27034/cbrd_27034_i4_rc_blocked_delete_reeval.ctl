/*
Test Case: cbrd_27034_i4_rc_blocked_delete_reeval
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Under READ COMMITTED a DELETE that waited for another updater re-evaluates its predicate on the committed version and leaves the row the update moved out of it.

NUM_CLIENTS = 3
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: SELECT COUNT(*) FROM t27034_t;
C1: UPDATE t27034_t SET k=99 WHERE id=2;
C2: DELETE FROM t27034_t WHERE k < 50; -- blocks
C1: COMMIT;
C2: (released)
C2: COMMIT;
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT);
C1: INSERT INTO t27034_t VALUES (1,10),(2,20),(3,30);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
MC: wait until C2 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C1: UPDATE t27034_t SET k=99 WHERE id=2;
MC: wait until C1 ready;
C2: DELETE FROM t27034_t WHERE k < 50;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C3: SELECT COUNT(*) FROM t27034_t;
MC: wait until C3 ready;
/* expect 2 */
C3: SELECT id FROM t27034_t;
MC: wait until C3 ready;
/* expect 99 */
C3: SELECT k FROM t27034_t WHERE id=2;
MC: wait until C3 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
