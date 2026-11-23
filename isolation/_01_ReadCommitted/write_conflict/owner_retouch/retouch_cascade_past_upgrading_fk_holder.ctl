/*
Test Case: owner_retouch/retouch_cascade_past_upgrading_fk_holder
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881), CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
Two transactions insert uncommitted children of a parent row, and one of them then waits to update the row on the stamp of the transaction that updated it in an earlier statement.
That owner then deletes the parent with ON DELETE CASCADE.
The owner must wait for the transactions of the uncommitted children instead of passing them: here it times out.
If it passed them, the cascade would miss the two uncommitted children and leave them without a parent.
CBRD-27034 wrote this case when the foreign key check of a child insert held S on the parent row, so the owner waited for two S holders, one of them waiting to upgrade to X.
Since CBRD-27463 the check takes no lock on a committed parent row, so the owner waits for a child's transaction instead.
The name keeps "fk_holder". This case no longer reaches the path where the owner waits for S holders on the row, and no other case covers that path.

NUM_CLIENTS = 3
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
C2: INSERT INTO t27034_c VALUES (10,1);
C3: INSERT INTO t27034_c VALUES (11,1);
C3: UPDATE t27034_p SET v=v+100 WHERE id=1; -- blocks: waits on C1's stamp
C1: DELETE FROM t27034_p WHERE id=1; -- waits for a child's transaction and times out after 2 seconds
C1: COMMIT;
C2: COMMIT;
C3: (released)
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
C3: INSERT INTO t27034_c VALUES (11,1);
MC: wait until C3 ready;
C3: UPDATE t27034_p SET v=v+100 WHERE id=1;
MC: wait until C3 blocked;
C1: set transaction lock timeout 2;
MC: wait until C1 ready;
/* CBRD-27463: the foreign key checks take no lock on a committed parent row, so the owner waits for a child's transaction, not for row locks, and times out there */
C1: DELETE FROM t27034_p WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_p WHERE id=1;
MC: wait until C2 ready;
/* expect 101 */
C2: SELECT v FROM t27034_p WHERE id=1;
MC: wait until C2 ready;
/* expect 2 */
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
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27034_c;
C1: DROP TABLE t27034_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
