/*
Test Case: fk_parent_restrict_check/child_moved_in_by_waiting_update_keeps_parent_fk_on_first_column
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A child UPDATE moves the row to a parent through a RESTRICT foreign key on its first column, and waits on the check of its foreign key on the second column, whose parent another transaction is deleting. A DELETE of the new parent meets the entry the UPDATE wrote for it and waits for the UPDATE.
The other DELETE rolls back, the UPDATE commits, and the parent DELETE fails on the foreign key, so no orphan is left.

NUM_CLIENTS = 3
C3: DELETE FROM t27463_hq WHERE id = 2;
C2: UPDATE t27463_hc SET a = 1, b = 2 WHERE id = 1;
C1: DELETE FROM t27463_hp WHERE id = 1;
C3: rollback work;
C2: commit work;
C1: rollback work;
*/

MC: setup NUM_CLIENTS = 3;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_hc;
C1: DROP TABLE IF EXISTS t27463_hp;
C1: DROP TABLE IF EXISTS t27463_hq;
C1: CREATE TABLE t27463_hp (id INT PRIMARY KEY);
C1: CREATE TABLE t27463_hq (id INT PRIMARY KEY);
C1: CREATE TABLE t27463_hc (id INT PRIMARY KEY, a INT, b INT, CONSTRAINT fk_t27463_hc_p FOREIGN KEY (a) REFERENCES t27463_hp (id), CONSTRAINT fk_t27463_hc_q FOREIGN KEY (b) REFERENCES t27463_hq (id));
C1: INSERT INTO t27463_hp VALUES (1);
C1: INSERT INTO t27463_hp VALUES (2);
C1: INSERT INTO t27463_hq VALUES (1);
C1: INSERT INTO t27463_hq VALUES (2);
C1: INSERT INTO t27463_hc VALUES (1, 2, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: DELETE FROM t27463_hq WHERE id = 2;
MC: wait until C3 ready;
C2: UPDATE t27463_hc SET a = 1, b = 2 WHERE id = 1;
MC: wait until C2 blocked;
/* expect an error */
C1: DELETE FROM t27463_hp WHERE id = 1;
MC: wait until C1 blocked;
C3: rollback work;
MC: wait until C3 ready;
MC: wait until C1 blocked;
MC: wait until C2 ready;
MC: wait until C1 blocked;
C2: commit work;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: rollback work;
MC: wait until C1 ready;

/* expected end state */
C1: SELECT id FROM t27463_hp ORDER BY id;
MC: wait until C1 ready;
C1: SELECT id FROM t27463_hq ORDER BY id;
MC: wait until C1 ready;
C1: SELECT id, a, b FROM t27463_hc ORDER BY id;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_hc c WHERE NOT EXISTS (SELECT 1 FROM t27463_hp p WHERE p.id = c.a);
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_hc;
C1: DROP TABLE t27463_hp;
C1: DROP TABLE t27463_hq;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
