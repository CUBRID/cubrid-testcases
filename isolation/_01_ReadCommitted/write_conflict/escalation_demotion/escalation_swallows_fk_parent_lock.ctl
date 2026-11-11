/*
Test Case: escalation_demotion/escalation_swallows_fk_parent_lock
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
As escalation_keeps_foreign_request, but the reclaimed lock is the S lock that the foreign key check took on parent
row 300 when the same transaction inserted a child earlier. The class lock stays X to commit, so another transaction's
UPDATE of an unrelated row (id 250) waits.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: INSERT INTO t27238_c VALUES (1, 300);
C1: DELETE FROM t27238_t WHERE id <= 200;
C2: UPDATE t27238_t SET v = 777 WHERE id = 250; -- blocks
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
C2: UPDATE t27238_t SET v = 777 WHERE id = 250;
MC: wait until C2 blocked;
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
