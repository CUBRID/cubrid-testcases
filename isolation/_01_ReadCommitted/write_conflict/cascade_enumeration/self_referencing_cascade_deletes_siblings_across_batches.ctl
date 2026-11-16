/*
Test Case: cascade_enumeration/self_referencing_cascade_deletes_siblings_across_batches
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The parent has 20000 children, more than one OID buffer of the child scan; the 19999 others reference the first through an ON DELETE CASCADE self reference. Deleting the first child deletes the others before the DELETE reaches them. All children are deleted.

NUM_CLIENTS = 1
C1: DELETE FROM t27464_parent WHERE id=1;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_parent;
C1: CREATE TABLE t27464_parent (id INT PRIMARY KEY);
C1: CREATE TABLE t27464_child (cid INT PRIMARY KEY, pid INT, sup INT, FOREIGN KEY (pid) REFERENCES t27464_parent(id) ON DELETE CASCADE, FOREIGN KEY (sup) REFERENCES t27464_child(cid) ON DELETE CASCADE);
C1: INSERT INTO t27464_parent VALUES (1);
C1: INSERT INTO t27464_child VALUES (1,1,NULL);
C1: INSERT INTO t27464_child (cid, pid, sup) SELECT 1 + LEVEL, 1, 1 FROM db_root CONNECT BY LEVEL <= 19999;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27464_parent WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_parent;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
