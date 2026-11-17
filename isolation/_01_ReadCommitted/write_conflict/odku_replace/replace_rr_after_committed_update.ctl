/*
Test Case: odku_replace/replace_rr_after_committed_update
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Under REPEATABLE READ a REPLACE of a row updated and committed after the snapshot fails with a serializable conflict.

NUM_CLIENTS = 3
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
C2: SELECT COUNT(*) FROM t27034_t;
C1: UPDATE t27034_t SET k=15 WHERE id=1;
C1: COMMIT;
C2: REPLACE INTO t27034_t VALUES (1, 100); -- fails
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
C1: INSERT INTO t27034_t VALUES (1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
MC: wait until C2 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C1: UPDATE t27034_t SET k=15 WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: REPLACE INTO t27034_t VALUES (1, 100);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C3: SELECT COUNT(*) FROM t27034_t;
MC: wait until C3 ready;
/* expect 15 */
C3: SELECT k FROM t27034_t WHERE id=1;
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
