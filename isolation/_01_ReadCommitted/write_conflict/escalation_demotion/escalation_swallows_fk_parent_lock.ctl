/*
Test Case: escalation_demotion/escalation_swallows_fk_parent_lock
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277), CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
As escalation_keeps_foreign_request, but the transaction inserted a child of parent row 300 before the DELETE.
Since CBRD-27463 the foreign key check of that insert takes no lock on the committed parent row, so the escalation
reclaims no lock of an earlier statement, and the class lock is lowered back to IX at statement end: another
transaction's UPDATE of an unrelated row (id 250) does not wait.
CBRD-27238 wrote this case when the check kept an S lock on row 300 to commit: the escalation reclaimed it, and the
class lock stayed X to commit. The name keeps "swallows_fk_parent_lock". escalation_keeps_foreign_request still
covers a reclaimed lock that keeps the class lock X.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: INSERT INTO t27238_c VALUES (1, 300);
C1: DELETE FROM t27238_t WHERE id <= 200;
C2: UPDATE t27238_t SET v = 777 WHERE id = 250; -- does not wait
C1: ROLLBACK;
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
C1: INSERT INTO t27238_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: CREATE TABLE t27238_c (id INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27238_t (id));
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: INSERT INTO t27238_c VALUES (1, 300);
MC: wait until C1 ready;
C1: DELETE FROM t27238_t WHERE id <= 200;
MC: wait until C1 ready;
/* CBRD-27463: the child insert took no lock on parent row 300, so the escalated class lock was lowered to IX and C2 does not wait */
C2: UPDATE t27238_t SET v = 777 WHERE id = 250;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 300 */
C2: SELECT COUNT(*) FROM t27238_t;
MC: wait until C2 ready;
/* expect 777 */
C2: SELECT v FROM t27238_t WHERE id = 250;
MC: wait until C2 ready;
/* expect 0 */
C2: SELECT COUNT(*) FROM t27238_c;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_c;
C1: DROP TABLE t27238_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
