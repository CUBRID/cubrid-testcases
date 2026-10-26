/*
Test Case: escalation_demotion/cascade_child_escalation_stays
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
A DELETE on the parent of an ON DELETE CASCADE foreign key escalates both the parent and the child class. At statement
end the parent class lock is lowered back to IX, so another transaction inserts into the parent without waiting. The
cascaded deletes are not the statement's own row locks, so the child class lock stays X to commit, and an INSERT into
the child waits until the deleting transaction ends.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE FROM t27238_parent WHERE id <= 200;
C2: INSERT INTO t27238_parent VALUES (999999, 0);
C2: INSERT INTO t27238_child VALUES (999999, 999999); -- blocks
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
C1: DROP TABLE IF EXISTS t27238_child;
C1: DROP TABLE IF EXISTS t27238_parent;
C1: CREATE TABLE t27238_parent (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_parent SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: CREATE TABLE t27238_child (id INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27238_parent (id) ON DELETE CASCADE);
C1: INSERT INTO t27238_child SELECT id, id FROM t27238_parent;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: DELETE FROM t27238_parent WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27238_parent VALUES (999999, 0);
MC: wait until C2 ready;
C2: INSERT INTO t27238_child VALUES (999999, 999999);
MC: wait until C2 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 301 */
C2: SELECT COUNT(*) FROM t27238_parent;
MC: wait until C2 ready;
/* expect 301 */
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
