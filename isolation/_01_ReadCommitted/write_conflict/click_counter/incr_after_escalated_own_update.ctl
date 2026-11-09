/*
Test Case: click_counter/incr_after_escalated_own_update
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
INCR on a row that an earlier, escalated UPDATE changed is part of the transaction, as in incr_after_own_update:
another transaction sees neither the update nor the increment before the commit, and both after it. The class lock is
lowered when the UPDATE ends, so the row request of the INCR is not covered by the class lock and goes through the
check for a row the transaction changed.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27238_cc SET hits = 100 WHERE id > 50;
C1: SELECT INCR(hits) FROM t27238_cc WHERE id = 60;
C2: SELECT hits FROM t27238_cc WHERE id = 60; -- 0
C1: COMMIT;
C2: SELECT hits FROM t27238_cc WHERE id = 60; -- 101
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
C1: DROP TABLE IF EXISTS t27238_cc;
C1: CREATE TABLE t27238_cc (id INT PRIMARY KEY, hits INT);
C1: INSERT INTO t27238_cc SELECT ROWNUM, 0 FROM db_class a, db_class b LIMIT 200;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27238_cc SET hits = 100 WHERE id > 50;
MC: wait until C1 ready;
/* expect 100 */
C1: SELECT INCR(hits) FROM t27238_cc WHERE id = 60;
MC: wait until C1 ready;
/* expect 101 */
C1: SELECT hits FROM t27238_cc WHERE id = 60;
MC: wait until C1 ready;
/* expect 0: neither the update nor the increment is committed */
C2: SELECT hits FROM t27238_cc WHERE id = 60;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 101 */
C2: SELECT hits FROM t27238_cc WHERE id = 60;
MC: wait until C2 ready;
/* expect 150 */
C2: SELECT COUNT(*) FROM t27238_cc WHERE hits >= 100;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_cc;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
