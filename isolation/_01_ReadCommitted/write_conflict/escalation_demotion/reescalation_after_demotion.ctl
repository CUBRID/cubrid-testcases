/*
Test Case: escalation_demotion/reescalation_after_demotion
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
After one statement escalates and is lowered, the next statement of the same transaction escalates the same class
again and is lowered again at its end. Another transaction's INSERT and UPDATE proceed before the first transaction
ends.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE FROM t27238_t WHERE id <= 200;
C1: DELETE FROM t27238_t WHERE id > 200 AND id <= 400;
C2: INSERT INTO t27238_t VALUES (999999, 0);
C2: UPDATE t27238_t SET v = 777 WHERE id = 500;
C2: COMMIT;
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
/* lock_escalation is a server parameter: a case that stopped before its clean up can leave another value */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t27238_t;
C1: CREATE TABLE t27238_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 600;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: DELETE FROM t27238_t WHERE id <= 200;
MC: wait until C1 ready;
C1: DELETE FROM t27238_t WHERE id > 200 AND id <= 400;
MC: wait until C1 ready;
C2: INSERT INTO t27238_t VALUES (999999, 0);
MC: wait until C2 ready;
C2: UPDATE t27238_t SET v = 777 WHERE id = 500;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 201 */
C1: SELECT COUNT(*) FROM t27238_t;
MC: wait until C1 ready;
/* expect 777 */
C1: SELECT v FROM t27238_t WHERE id = 500;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
