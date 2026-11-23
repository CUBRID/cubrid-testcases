/*
Test Case: fk_parent_restrict_check/restrict_stops_at_committed_child
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
C1 updates parent 1, C2 and C3 insert children of it, and C3 then updates parent 1 and waits on C1. C1 deletes
parent 1 (ON DELETE RESTRICT) and waits for the child of C2. Once C2 commits, the DELETE sees a committed child and
fails on the foreign key without waiting for the child of C3, and C3 goes on after C1 commits. Only the DELETE of
C1 fails: its UPDATE commits.
Before CBRD-27654 the DELETE also waited for the child of C3 while C3 waited on C1: a deadlock.

NUM_CLIENTS = 3
C1: UPDATE t27654_parent SET v = v + 1 WHERE id = 1;
C2: INSERT INTO t27654_child VALUES (10, 1);
C3: INSERT INTO t27654_child VALUES (11, 1);
C3: UPDATE t27654_parent SET v = v + 100 WHERE id = 1; -- waits on C1
C1: DELETE FROM t27654_parent WHERE id = 1; -- waits on C2
C2: COMMIT;
C1: (fails on the foreign key)
C1: COMMIT;
C3: (goes on)
C3: COMMIT;
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
C1: DROP TABLE IF EXISTS t27654_child;
C1: DROP TABLE IF EXISTS t27654_parent;
C1: CREATE TABLE t27654_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27654_child (cid INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27654_parent (id) ON DELETE RESTRICT);
C1: INSERT INTO t27654_parent VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27654_parent SET v = v + 1 WHERE id = 1;
MC: wait until C1 ready;
C2: INSERT INTO t27654_child VALUES (10, 1);
MC: wait until C2 ready;
C3: INSERT INTO t27654_child VALUES (11, 1);
MC: wait until C3 ready;
C3: UPDATE t27654_parent SET v = v + 100 WHERE id = 1;
MC: wait until C3 blocked;
C1: DELETE FROM t27654_parent WHERE id = 1;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 1 101, 2 0 */
C1: SELECT id, v FROM t27654_parent ORDER BY id;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27654_child;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27654_child;
C1: DROP TABLE t27654_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
