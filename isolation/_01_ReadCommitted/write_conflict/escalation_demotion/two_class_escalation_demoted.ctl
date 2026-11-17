/*
Test Case: escalation_demotion/two_class_escalation_demoted
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
An UPDATE of two tables escalates both classes, and both are lowered at statement end: another transaction inserts
into each table without waiting.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27238_t, t27238_m2 SET t27238_t.v = t27238_t.v + 1, t27238_m2.v = t27238_m2.v + 1 WHERE t27238_t.id = t27238_m2.id AND t27238_t.id <= 200;
C2: INSERT INTO t27238_t VALUES (999999, 0);
C2: INSERT INTO t27238_m2 VALUES (999999, 0);
C2: COMMIT;
C1: ROLLBACK;
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
C1: DROP TABLE IF EXISTS t27238_m2;
C1: DROP TABLE IF EXISTS t27238_t;
C1: CREATE TABLE t27238_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: CREATE TABLE t27238_m2 (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_m2 SELECT id, v FROM t27238_t;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27238_t, t27238_m2 SET t27238_t.v = t27238_t.v + 1, t27238_m2.v = t27238_m2.v + 1 WHERE t27238_t.id = t27238_m2.id AND t27238_t.id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27238_t VALUES (999999, 0);
MC: wait until C2 ready;
C2: INSERT INTO t27238_m2 VALUES (999999, 0);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 301 */
C1: SELECT COUNT(*) FROM t27238_t;
MC: wait until C1 ready;
/* expect 301 */
C1: SELECT COUNT(*) FROM t27238_m2;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_m2;
C1: DROP TABLE t27238_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
