/*
Test Case: escalation_demotion/escalation_withdrawn_by_self_fk
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
On a self-referencing table, an UPDATE that sets the foreign key column checks the parent row for every updated row
and keeps an S lock on it to commit. These checks reach the class after it escalated, so the lowering is withdrawn and
the class lock stays X to commit: another transaction's INSERT waits until the first transaction ends.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27238_t SET v = v + 1, pid = 300 WHERE id <= 200;
C2: INSERT INTO t27238_t VALUES (999999, 0, 300); -- blocks
C1: ROLLBACK;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27238_t;
C1: CREATE TABLE t27238_t (id INT PRIMARY KEY, v INT, pid INT, FOREIGN KEY (pid) REFERENCES t27238_t (id));
C1: INSERT INTO t27238_t SELECT ROWNUM, ROWNUM, NULL FROM db_class a, db_class b LIMIT 300;
C1: UPDATE t27238_t SET pid = 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27238_t SET v = v + 1, pid = 300 WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27238_t VALUES (999999, 0, 300);
MC: wait until C2 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 301 */
C2: SELECT COUNT(*) FROM t27238_t;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27238_t WHERE id = 999999;
MC: wait until C2 ready;

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
