/*
Test Case: fk_parent_early_writer/restrict_delete_finds_own_child_behind_waiting_for_update
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction updates a child, another transaction's SELECT ... FOR UPDATE of that child waits on it, and the first transaction then deletes the parent (ON DELETE RESTRICT).
The restrict check finds the child the transaction last wrote without queuing behind the waiting reader, so the DELETE fails on the foreign key at once and the two do not deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27463_child SET x = 1 WHERE id = 0;
C2: SELECT * FROM t27463_child WHERE id = 0 FOR UPDATE;
C1: DELETE FROM t27463_parent WHERE id = 7;
C1: commit work;
C2: commit work;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, x INT, CONSTRAINT fk_t27463_child FOREIGN KEY (pid) REFERENCES t27463_parent (id));
C1: INSERT INTO t27463_parent VALUES (7, 0);
C1: INSERT INTO t27463_parent VALUES (8, 0);
C1: INSERT INTO t27463_child VALUES (0, 7, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27463_child SET x = 1 WHERE id = 0;
MC: wait until C1 ready;
C2: SELECT * FROM t27463_child WHERE id = 0 FOR UPDATE;
MC: wait until C2 blocked;
/* expect an error */
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 ready;
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;

/* expected end state */
C1: SELECT id, v FROM t27463_parent ORDER BY id;
MC: wait until C1 ready;
C1: SELECT id, pid, x FROM t27463_child ORDER BY id;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id = c.pid);
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
