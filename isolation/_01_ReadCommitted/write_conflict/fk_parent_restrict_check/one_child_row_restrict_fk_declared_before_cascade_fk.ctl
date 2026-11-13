/*
Test Case: fk_parent_restrict_check/one_child_row_restrict_fk_declared_before_cascade_fk
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A child row refers to the same parent through an ON DELETE CASCADE foreign key and through a RESTRICT one, the RESTRICT one declared first.
The restrict check runs before the cascade and finds the row, so the parent DELETE fails on the foreign key.

NUM_CLIENTS = 1
C1: DELETE FROM t27463_parent WHERE id = 1;
C1: rollback work;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, a INT, b INT, CONSTRAINT fk_t27463_fb FOREIGN KEY (b) REFERENCES t27463_parent (id), CONSTRAINT fk_t27463_fa FOREIGN KEY (a) REFERENCES t27463_parent (id) ON DELETE CASCADE);
C1: INSERT INTO t27463_parent VALUES (1, 0);
C1: INSERT INTO t27463_child VALUES (10, 1, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
/* expect an error */
C1: DELETE FROM t27463_parent WHERE id = 1;
MC: wait until C1 ready;
C1: rollback work;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT id FROM t27463_parent ORDER BY id;
MC: wait until C1 ready;
C1: SELECT id, a, b FROM t27463_child ORDER BY id;
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
