/*
Test Case: escalation_demotion/rollback_after_demotion_restores_updated_rows
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
An UPDATE that escalates has its class lock lowered to IX at statement end, and then its transaction rolls back. Until
the rollback ends, the rows it changed stay protected by the updater's transaction lock. An UPDATE of id 5, changed
before the escalation, whose row lock the escalation took back, and an UPDATE of id 150, changed after the
escalation, under the class lock only, both wait. An UPDATE of a row the statement did not change (id 299) does not
wait. After the ROLLBACK the waiters build on the restored value, not on the rolled back one: v ends as 1, not 101.

NUM_CLIENTS = 3
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27238_t SET v = v + 100 WHERE id <= 200; -- escalates, lowered at statement end
C2: UPDATE t27238_t SET v = v + 1 WHERE id = 299; -- does not wait
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
C1: UPDATE t27238_t SET v = v + 100 WHERE id <= 200;
MC: wait until C1 ready;
/* a row the UPDATE did not change: it does not wait for C1 */
C2: UPDATE t27238_t SET v = v + 1 WHERE id = 299;
MC: wait until C2 ready;
/* changed before the escalation: waits for C1 to end */
C2: UPDATE t27238_t SET v = v + 1 WHERE id = 5;
MC: wait until C2 blocked;
/* changed after the escalation: waits for C1 to end */
C3: UPDATE t27238_t SET v = v + 1 WHERE id = 150;
MC: wait until C3 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
/* expect 1 row each */
MC: wait until C2 ready;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect (5, 1), (150, 1) and (299, 1): C1's +100 is gone everywhere */
C1: SELECT id, v FROM t27238_t WHERE v > 0 ORDER BY id;
MC: wait until C1 ready;
/* expect 300 */
C1: SELECT COUNT (*) FROM t27238_t;
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
