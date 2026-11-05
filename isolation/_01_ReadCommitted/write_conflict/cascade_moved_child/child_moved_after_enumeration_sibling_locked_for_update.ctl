/*
Test Case: cascade_moved_child/child_moved_after_enumeration_sibling_locked_for_update
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The DELETE enumerates two committed children and waits on one that another transaction locked FOR UPDATE; meanwhile a third transaction moves the other child to another parent and commits. The DELETE re-checks that child after its lock and keeps it.

NUM_CLIENTS = 3
C1: SELECT * FROM t27464_child WHERE cid=10 FOR UPDATE;
C2: DELETE FROM t27464_parent WHERE id=1;
C3: UPDATE t27464_child SET pid=2 WHERE cid=11;
C3: COMMIT;
C1: COMMIT;
C2: COMMIT;
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
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_parent;
C1: CREATE TABLE t27464_parent (id INT PRIMARY KEY, name VARCHAR(20));
C1: CREATE TABLE t27464_child (cid INT PRIMARY KEY, pid INT, note VARCHAR(20), FOREIGN KEY (pid) REFERENCES t27464_parent(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27464_child VALUES (10,1,'a');
C1: INSERT INTO t27464_child VALUES (11,1,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT * FROM t27464_child WHERE cid=10 FOR UPDATE;
MC: wait until C1 ready;
C2: DELETE FROM t27464_parent WHERE id=1;
MC: wait until C2 blocked;
C3: UPDATE t27464_child SET pid=2 WHERE cid=11;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_parent;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE cid=10;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE cid=11 AND pid=2;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE NOT EXISTS (SELECT 1 FROM t27464_parent p WHERE p.id=c.pid);
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
