/*
Test Case: escalation_demotion/rollback_after_demotion_restores_deleted_rows
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
A DELETE that escalates has its class lock lowered to IX at statement end, and then its transaction rolls back. Until
the rollback ends, the rows it deleted stay protected by the deleter's transaction lock, not by a row lock or the
class lock. Two such rows are checked: id 5, deleted before the escalation, whose row lock the escalation took back,
and id 150, deleted after the escalation, under the class lock only. An UPDATE of each waits. An INSERT of a row the
DELETE did not touch does not wait. After the ROLLBACK the waiters find the rows restored and each updates one row.
commit_after_demotion_deleted_rows_gone is the same order with a COMMIT.

NUM_CLIENTS = 3
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE FROM t27238_t WHERE id <= 200; -- escalates, lowered at statement end
C2: INSERT INTO t27238_t VALUES (1000, 0); -- does not wait
C2: UPDATE t27238_t SET v = v + 1 WHERE id = 5; -- blocks
C3: UPDATE t27238_t SET v = v + 1 WHERE id = 150; -- blocks
C1: ROLLBACK;
C2: (released, 1 row)
C3: (released, 1 row)
C2: COMMIT;
C3: COMMIT;
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
/* lock_escalation is a server parameter: a case that stopped before its clean up can leave another value */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t27238_t;
C1: CREATE TABLE t27238_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_t SELECT ROWNUM, 0 FROM db_class x, db_class y LIMIT 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
/* expect 200 rows; the statement escalates and its class lock is lowered to IX at its end */
C1: DELETE FROM t27238_t WHERE id <= 200;
MC: wait until C1 ready;
/* a row the DELETE did not touch: it does not wait for C1 */
C2: INSERT INTO t27238_t VALUES (1000, 0);
MC: wait until C2 ready;
/* deleted before the escalation: waits for C1 to end */
C2: UPDATE t27238_t SET v = v + 1 WHERE id = 5;
MC: wait until C2 blocked;
/* deleted after the escalation: waits for C1 to end */
C3: UPDATE t27238_t SET v = v + 1 WHERE id = 150;
MC: wait until C3 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
/* expect 1 row each: the deleted rows are back */
MC: wait until C2 ready;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 301 */
C1: SELECT COUNT (*) FROM t27238_t;
MC: wait until C1 ready;
/* expect (5, 1) and (150, 1) */
C1: SELECT id, v FROM t27238_t WHERE v > 0 ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
