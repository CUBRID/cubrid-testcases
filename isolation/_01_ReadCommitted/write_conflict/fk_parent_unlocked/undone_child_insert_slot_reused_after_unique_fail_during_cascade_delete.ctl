/*
Test Case: fk_parent_unlocked/undone_child_insert_slot_reused_after_unique_fail_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
C4 inserts child 50 with unique value 90 and stays open. C2 inserts child 9 of parent 7 with the same unique value and waits for C4. The parent DELETE (ON DELETE CASCADE) of C1 finds the insert of C2 in progress and waits for C2.
C4 commits, the INSERT of C2 fails on the unique key, and its heap slot is freed while C2 stays open. C3 inserts child 10 of parent 8, which takes that slot, and stays open.
After the commit of C2, the DELETE of C1 sees that the slot holds another row and does not wait for C3. The DELETE removes parent 7 and child 2. The UPDATE of parent 7 by C3 waits for C1, and the two do not deadlock.

NUM_CLIENTS = 4
C4: INSERT INTO t27463_child VALUES (50, 8, 90, 0);
C2: INSERT INTO t27463_child VALUES (9, 7, 90, 0);
C1: DELETE FROM t27463_parent WHERE id = 7;
C4: COMMIT;
C3: INSERT INTO t27463_child VALUES (10, 8, 100, 0);
C2: COMMIT;
C3: UPDATE t27463_parent SET v = v + 1 WHERE id = 7;
C1: COMMIT;
C3: COMMIT;
*/

MC: setup NUM_CLIENTS = 4;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C4: login as 'dba';
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, u INT, x INT, FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE CASCADE);
C1: CREATE UNIQUE INDEX t27463_child_u ON t27463_child (u);
C1: INSERT INTO t27463_parent VALUES (7,0),(8,0);
C1: INSERT INTO t27463_child VALUES (2,7,20,0),(4,8,40,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C4: INSERT INTO t27463_child VALUES (50, 8, 90, 0);
MC: wait until C4 ready;
C2: INSERT INTO t27463_child VALUES (9, 7, 90, 0);
MC: wait until C2 blocked;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
C4: COMMIT;
MC: wait until C4 ready;
/* expect a unique key error */
MC: wait until C2 ready;
C3: INSERT INTO t27463_child VALUES (10, 8, 100, 0);
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: UPDATE t27463_parent SET v = v + 1 WHERE id = 7;
MC: wait until C3 blocked;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27463_parent;
MC: wait until C1 ready;
/* expect 3 */
C1: SELECT COUNT(*) FROM t27463_child;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_parent p WHERE p.id=c.pid);
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C4: rollback work;
MC: wait until C4 ready;
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
