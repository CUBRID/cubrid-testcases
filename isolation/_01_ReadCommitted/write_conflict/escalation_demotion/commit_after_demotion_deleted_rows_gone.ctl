/*
Test Case: escalation_demotion/commit_after_demotion_deleted_rows_gone
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
The order of rollback_after_demotion_restores_deleted_rows, with a COMMIT where that case rolls back. A DELETE that
escalates has its class lock lowered to IX at statement end. An UPDATE of id 5, deleted before the escalation, whose
row lock the escalation took back, and an UPDATE of id 150, deleted after the escalation, under the class lock only,
wait for the deleter's transaction to end. After the COMMIT they find the rows gone and update nothing. An INSERT of a
row the DELETE did not touch does not wait.

NUM_CLIENTS = 3
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE FROM t27238_t WHERE id <= 200; -- escalates, lowered at statement end
C2: INSERT INTO t27238_t VALUES (1000, 0); -- does not wait
C2: UPDATE t27238_t SET v = v + 1 WHERE id = 5; -- blocks
C3: UPDATE t27238_t SET v = v + 1 WHERE id = 150; -- blocks
C1: COMMIT;
C2: (released, 0 rows)
C3: (released, 0 rows)
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
C1: COMMIT;
MC: wait until C1 ready;
/* expect 0 rows each: the rows are gone */
MC: wait until C2 ready;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 101 rows: id 201 to 300 and 1000 */
C1: SELECT COUNT (*), MIN (id), MAX (id) FROM t27238_t;
MC: wait until C1 ready;
/* expect no row */
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
