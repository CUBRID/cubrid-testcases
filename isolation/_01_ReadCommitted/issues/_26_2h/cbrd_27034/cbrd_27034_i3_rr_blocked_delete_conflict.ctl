/*
Test Case: cbrd_27034_i3_rr_blocked_delete_conflict
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Under REPEATABLE READ a DELETE that waited for another updater fails with a serializable conflict once that updater commits; all three rows remain.

NUM_CLIENTS = 3
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
C2: SELECT COUNT(*) FROM t27034_t;
C1: UPDATE t27034_t SET k=99 WHERE id=2;
C2: DELETE FROM t27034_t WHERE k < 50; -- blocks
C1: COMMIT;
C2: (released, fails)
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
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
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
/* expect 3 */
C3: SELECT COUNT(*) FROM t27034_t;
MC: wait until C3 ready;
/* expect 99 */
C3: SELECT k FROM t27034_t WHERE id=2;
MC: wait until C3 ready;
/* expect 10 */
C3: SELECT k FROM t27034_t WHERE id=1;
MC: wait until C3 ready;
/* expect 30 */
C3: SELECT k FROM t27034_t WHERE id=3;
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
