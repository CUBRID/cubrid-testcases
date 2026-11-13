/*
Test Case: fk_parent_unlocked/child_insert_into_slot_of_failed_child_insert
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198), CBRD-26942
Author: hgryoo

Test Point:
A child INSERT fails its foreign key check; its row is rolled back and its heap slot freed while its transaction stays open.
Another transaction inserts a child of an existing parent, which may land in that slot. The INSERT does not wait for the first
transaction, and it adds the child to the foreign key and primary key indexes, so the parent cannot be deleted while the child exists.

NUM_CLIENTS = 2
C1: INSERT INTO t27463_child VALUES (1, 99, 'x');
C2: set transaction lock timeout 1;
C2: INSERT INTO t27463_child VALUES (2, 1, 'n');
C2: COMMIT;
C1: COMMIT;
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
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27463_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27463_parent(id));
C1: INSERT INTO t27463_parent VALUES (1,'a'),(2,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t27463_child VALUES (1, 99, 'x');
MC: wait until C1 ready;
C2: set transaction lock timeout 1;
MC: wait until C2 ready;
C2: INSERT INTO t27463_child VALUES (2, 1, 'n');
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;
C1: commit work;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child WHERE cid = 2 USING INDEX pk_t27463_child_cid;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child WHERE pid = 1 USING INDEX fk_t27463_child_pid;
MC: wait until C1 ready;
/* expect a foreign key error */
C1: DELETE FROM t27463_parent WHERE id = 1;
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
