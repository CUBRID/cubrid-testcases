/*
Test Case: cbrd_27034_f5_parent_key_update_new_ref
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A child INSERT that refers to the new key of a parent whose key is being updated waits, and goes in once the update commits.

NUM_CLIENTS = 2
C1: UPDATE t27034_father SET id=5 WHERE id=2;
C2: INSERT INTO t27034_child VALUES (10, 5); -- blocks
C1: COMMIT;
C2: (released)
C2: COMMIT;
C1: SELECT COUNT(*) FROM t27034_child WHERE fid=5;
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
C1: DROP TABLE IF EXISTS t27034_child;
C1: DROP TABLE IF EXISTS t27034_father;
C1: CREATE TABLE t27034_father (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27034_child (id INT PRIMARY KEY, fid INT, FOREIGN KEY (fid) REFERENCES t27034_father(id));
C1: INSERT INTO t27034_father VALUES (1,'a'),(2,'b');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_father SET id=5 WHERE id=2;
MC: wait until C1 ready;
C2: INSERT INTO t27034_child VALUES (10, 5);
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: SELECT COUNT(*) FROM t27034_child WHERE fid=5;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_child WHERE fid=5;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_child;
C1: DROP TABLE t27034_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
