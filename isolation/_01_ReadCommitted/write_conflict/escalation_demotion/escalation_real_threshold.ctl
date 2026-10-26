/*
Test Case: escalation_demotion/escalation_real_threshold
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
With the default lock_escalation (100000), a DELETE of 120000 rows escalates. The class lock is back at IX when the
statement ends, so another transaction inserts an unrelated row before the deleting transaction ends. Without the
lowering the INSERT waits until the DELETE commits or rolls back.

NUM_CLIENTS = 2
C1: DELETE FROM t27238_big;
C2: INSERT INTO t27238_big VALUES (999999, 0);
C2: COMMIT;
C1: ROLLBACK;
C2: SELECT COUNT(*) FROM t27238_big;
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
C1: DROP TABLE IF EXISTS t27238_big;
C1: CREATE TABLE t27238_big (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_big SELECT ROWNUM, ROWNUM FROM db_class x, db_class y, db_class z LIMIT 120000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27238_big;
MC: wait until C1 ready;
C2: INSERT INTO t27238_big VALUES (999999, 0);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27238_big;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 120001 */
C2: SELECT COUNT(*) FROM t27238_big;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27238_big WHERE id=999999;
MC: wait until C2 ready;

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
