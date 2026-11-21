/*
Test Case: fk_parent_unlocked/child_insert_then_parent_nonkey_update
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
An uncommitted child INSERT holds no lock on the parent row it references, so an UPDATE of a non-key column of that parent does not wait for it.

NUM_CLIENTS = 2
C2: INSERT INTO t27463_child VALUES (10, 2);
C1: UPDATE t27463_father SET note='changed' WHERE id=2;
C1: COMMIT;
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
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_father;
C1: CREATE TABLE t27463_father (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27463_father(id));
C1: INSERT INTO t27463_father VALUES (1,'a'),(2,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27463_child VALUES (10, 2);
MC: wait until C2 ready;
C1: UPDATE t27463_father SET note='changed' WHERE id=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_child WHERE fid=2;
MC: wait until C1 ready;
/* expect changed */
C1: SELECT note FROM t27463_father WHERE id=2;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE NOT EXISTS (SELECT 1 FROM t27463_father f WHERE f.id=c.fid);
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
