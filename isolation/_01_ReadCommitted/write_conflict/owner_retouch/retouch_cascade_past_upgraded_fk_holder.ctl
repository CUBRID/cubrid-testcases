/*
Test Case: owner_retouch/retouch_cascade_past_upgraded_fk_holder
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881), CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction inserts an uncommitted child of a parent row, then waits to update the parent on the stamp of the transaction that updated it in an earlier statement.
That owner then deletes the parent with ON DELETE CASCADE.
The owner must wait for the child's transaction instead of passing it: here the owner has no lock timeout and fails at once.
If it passed it, the cascade would miss the uncommitted child and leave it without a parent.
A lock timeout of 0 keeps the owner out of the deadlock the wait would close, so the output order is fixed.
CBRD-27034 wrote this case when the foreign key check of a child insert held S on the parent row, so the owner waited for an S hidden in the X of the child's transaction.
Since CBRD-27463 the check takes no lock on a committed parent row, so the owner waits for the child's transaction instead.
The name keeps "fk_holder". This case no longer reaches the path where the owner waits for S holders on the row, and no other case covers that path.

NUM_CLIENTS = 2
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
C2: INSERT INTO t27034_c VALUES (10,1);
C2: UPDATE t27034_p SET v=v+100 WHERE id=1; -- blocks: waits on C1's stamp
C1: DELETE FROM t27034_p WHERE id=1; -- must wait for C2's transaction, and times out at once
C1: COMMIT;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27034_c;
C1: DROP TABLE IF EXISTS t27034_p;
C1: CREATE TABLE t27034_p (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27034_c (cid INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27034_p (id) ON DELETE CASCADE);
C1: INSERT INTO t27034_p VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: INSERT INTO t27034_c VALUES (10,1);
MC: wait until C2 ready;
C2: UPDATE t27034_p SET v=v+100 WHERE id=1;
MC: wait until C2 blocked;
C1: set transaction lock timeout 0;
MC: wait until C1 ready;
/* CBRD-27463: the foreign key check takes no lock on a committed parent row, so the owner waits for the child's transaction, not for a row lock, and times out there */
C1: DELETE FROM t27034_p WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_p WHERE id=1;
MC: wait until C2 ready;
/* expect 101 */
C2: SELECT v FROM t27034_p WHERE id=1;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_c;
MC: wait until C2 ready;
/* expect 0 */
C2: SELECT COUNT(*) FROM t27034_c c WHERE NOT EXISTS (SELECT 1 FROM t27034_p p WHERE p.id = c.pid);
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_c;
C1: DROP TABLE t27034_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
