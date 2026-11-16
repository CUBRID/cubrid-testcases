/*
Test Case: escalation_demotion/shape_join_delete
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
As shape_plain_update, with a join DELETE whose second table only contributes one constant row.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE t27238_t FROM t27238_t, t27238_c WHERE t27238_t.id <= 200 AND t27238_c.id = 1;
C2: UPDATE t27238_t SET v=v+5 WHERE id=299;
C2: COMMIT;
C1: ROLLBACK;
C2: SELECT COUNT(*) FROM t27238_t;
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
/* lock_escalation is a server parameter: a case that stopped before its clean up can leave another value */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t27238_c;
C1: DROP TABLE IF EXISTS t27238_t;
C1: CREATE TABLE t27238_t (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27238_c (id INT PRIMARY KEY, w INT);
C1: INSERT INTO t27238_t SELECT ROWNUM, 0 FROM db_class x, db_class y LIMIT 300;
C1: INSERT INTO t27238_c VALUES (1, 7);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: DELETE t27238_t FROM t27238_t, t27238_c WHERE t27238_t.id <= 200 AND t27238_c.id = 1;
MC: wait until C1 ready;
C2: UPDATE t27238_t SET v=v+5 WHERE id=299;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27238_t;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 300 */
C2: SELECT COUNT(*) FROM t27238_t;
MC: wait until C2 ready;
/* expect 5 */
C2: SELECT v FROM t27238_t WHERE id=299;
MC: wait until C2 ready;
/* expect 5 */
C2: SELECT SUM(v) FROM t27238_t;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27238_c;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_t;
C1: DROP TABLE t27238_c;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
