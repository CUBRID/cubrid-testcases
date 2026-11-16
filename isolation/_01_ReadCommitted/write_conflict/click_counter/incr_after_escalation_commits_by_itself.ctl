/*
Test Case: click_counter/incr_after_escalation_commits_by_itself
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
INCR after a statement that escalated. The class lock is lowered at statement end, so INCR on a row the transaction
has not changed commits by itself, as in incr_alone_commits_by_itself, and the increment stays after a rollback.
Before this change the class X lock left by the escalation covered the row request of the INCR, and the increment
rolled back with the transaction.

NUM_CLIENTS = 1
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27238_cc SET name='x' WHERE id > 50;
C1: SELECT INCR(hits) FROM t27238_cc WHERE id=1;
C1: ROLLBACK;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
/* lock_escalation is a server parameter: a case that stopped before its clean up can leave another value */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t27238_cc;
C1: CREATE TABLE t27238_cc (id INT PRIMARY KEY, hits INT, name VARCHAR(10));
C1: INSERT INTO t27238_cc SELECT ROWNUM, 0, 'a' FROM db_class a, db_class b LIMIT 200;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27238_cc SET name='x' WHERE id > 50;
MC: wait until C1 ready;
C1: SELECT INCR(hits) FROM t27238_cc WHERE id=1;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT hits FROM t27238_cc WHERE id=1;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27238_cc WHERE name='x';
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_cc;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
