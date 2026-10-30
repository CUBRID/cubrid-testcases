/*
Test Case: escalation_demotion/referenced_parent_delete_demoted
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
A DELETE of referenced parent rows (RESTRICT, with rows in the child table) escalates only the parent class, and the
foreign key checks do not withdraw the lowering: another transaction inserts into the parent without waiting.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE FROM t27238_parent WHERE id <= 200;
C2: INSERT INTO t27238_parent VALUES (999999, 0);
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
C1: DROP TABLE IF EXISTS t27238_child;
C1: DROP TABLE IF EXISTS t27238_parent;
C1: CREATE TABLE t27238_parent (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_parent SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: CREATE TABLE t27238_child (id INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27238_parent (id));
C1: INSERT INTO t27238_child VALUES (1, 300);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: DELETE FROM t27238_parent WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27238_parent VALUES (999999, 0);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 301 */
C2: SELECT COUNT(*) FROM t27238_parent;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27238_child;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_child;
C1: DROP TABLE t27238_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
