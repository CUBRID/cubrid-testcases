/*
Test Case: fk_parent_unlocked/child_updater_deletes_parent_behind_key_change_on_its_child
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198), CBRD-26664
Author: hgryoo

Test Point:
A transaction's UPDATE of two children has locked the first and waits for the second, a change of the first child's parent key (ON UPDATE SET NULL) waits for that first child, and the UPDATE's transaction then deletes the parent its children now refer to.
The restrict check finds the children the transaction last wrote without queuing behind the key change, so the DELETE fails on the foreign key at once and the two do not deadlock; the key change then goes through.

NUM_CLIENTS = 3
C3: SELECT cid FROM t27463_child WHERE cid = 20 FOR UPDATE;
C2: UPDATE t27463_child SET pid = 2 WHERE cid IN (10, 20);
C1: UPDATE t27463_parent SET id = 5 WHERE id = 1;
C3: COMMIT;
C2: DELETE FROM t27463_parent WHERE id = 2;
C2: COMMIT;
C1: COMMIT;
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
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27463_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON UPDATE SET NULL);
C1: INSERT INTO t27463_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27463_child VALUES (10,1,'c'),(20,1,'d');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: SELECT cid FROM t27463_child WHERE cid = 20 FOR UPDATE;
MC: wait until C3 ready;
C2: UPDATE t27463_child SET pid = 2 WHERE cid IN (10, 20);
MC: wait until C2 blocked;
C1: UPDATE t27463_parent SET id = 5 WHERE id = 1;
MC: wait until C1 blocked;
C3: COMMIT;
MC: wait until C3 ready;
MC: wait until C2 ready;
C2: DELETE FROM t27463_parent WHERE id = 2;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27463_child WHERE pid = 2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_parent WHERE id = 5;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
