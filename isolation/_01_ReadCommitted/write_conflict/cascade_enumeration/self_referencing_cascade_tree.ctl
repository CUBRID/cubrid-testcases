/*
Test Case: cascade_enumeration/self_referencing_cascade_tree
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
Deleting the root of a self-referencing ON DELETE CASCADE tree deletes the whole tree and leaves the other tree alone.

NUM_CLIENTS = 1
C1: DELETE FROM t27464_node WHERE id=1;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_node;
C1: CREATE TABLE t27464_node (id INT PRIMARY KEY, up INT, FOREIGN KEY (up) REFERENCES t27464_node(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_node VALUES (1, NULL);
C1: INSERT INTO t27464_node VALUES (2, 1), (3, 1);
C1: INSERT INTO t27464_node VALUES (4, 2), (5, 4), (6, 3);
C1: INSERT INTO t27464_node VALUES (7, NULL), (8, 7);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27464_node WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27464_node;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_node WHERE id=8 AND up=7;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27464_node;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
