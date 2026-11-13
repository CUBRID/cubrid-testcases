/*
Test Case: escalation_demotion/escalation_update_demoted
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
The UPDATE form of escalation_real_threshold: an UPDATE of 120000 rows escalates at the default threshold and is
lowered at statement end, so another transaction inserts a new key without waiting.

NUM_CLIENTS = 2
C1: UPDATE t27238_big SET v = v + 1;
C2: INSERT INTO t27238_big VALUES (999999, 0);
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
C1: DROP TABLE IF EXISTS t27238_big;
C1: CREATE TABLE t27238_big (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_big SELECT ROWNUM, ROWNUM FROM db_class a, db_class b, db_class c LIMIT 120000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27238_big SET v = v + 1;
MC: wait until C1 ready;
C2: INSERT INTO t27238_big VALUES (999999, 0);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 120001 */
C1: SELECT COUNT(*) FROM t27238_big;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27238_big WHERE id = 999999;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27238_big;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
