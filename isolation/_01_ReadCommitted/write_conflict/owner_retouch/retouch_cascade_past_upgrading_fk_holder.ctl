/*
Test Case: owner_retouch/retouch_cascade_past_upgrading_fk_holder
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Two transactions hold S on a parent row through the foreign-key checks of their child inserts, and one of them waits to upgrade it to X.
The transaction that updated the parent in an earlier statement then deletes it with ON DELETE CASCADE.
The owner must wait for the S locks, also the one held beside the upgrade, instead of passing them: here it times out.
If it passed them, the cascade would miss the two uncommitted children and leave them without a parent.

NUM_CLIENTS = 3
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
C2: INSERT INTO t27034_c VALUES (10,1);
C3: INSERT INTO t27034_c VALUES (11,1);
C3: UPDATE t27034_p SET v=v+100 WHERE id=1; -- blocks: S to X upgrade behind C2's S
C1: DELETE FROM t27034_p WHERE id=1; -- waits for the S locks and times out after 2 seconds
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
/* the owner waits for the S locks of C2 and C3 and times out */
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
