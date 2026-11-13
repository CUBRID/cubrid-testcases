/*
Test Case: fk_parent_unlocked/undone_child_insert_slot_taken_by_moved_row_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
The heap slot that an undone insert freed can also take the new home of another row that an UPDATE moves (REC_NEWHOME). Reading that slot as a gathered child must find no row there, not an error.
Children 1 (of parent 7) and 2 (of parent 8) fill the first heap page. C2 inserts child 9 of parent 7 under a savepoint into a new page and stays open. The parent DELETE (ON DELETE CASCADE) of C1 finds the insert in progress and waits for C2.
C2 rolls back to the savepoint, which frees slot 1 of the new page while C2 stays open. C3 makes child 2 larger than the free space of the first page and commits, so the new home of child 2 takes that slot.
After the commit of C2, the DELETE of C1 removes parent 7 and child 1 without an error.

NUM_CLIENTS = 3
C2: SAVEPOINT sp;
C2: INSERT INTO t27463_child VALUES (9, 7, CAST (REPEAT ('ab', 2000) AS BIT VARYING));
C1: DELETE FROM t27463_parent WHERE id = 7;
C2: ROLLBACK TO SAVEPOINT sp;
C3: UPDATE t27463_child SET pad = CAST (REPEAT ('ab', 10000) AS BIT VARYING) WHERE id = 2;
C3: COMMIT;
C2: COMMIT;
C1: COMMIT;
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
/* children 1 and 2 fill the first heap page to about 1.5K free; BIT VARYING values are not compressed, so their sizes hold */
C1: DROP TABLE IF EXISTS t27463_child;
C1: DROP TABLE IF EXISTS t27463_parent;
C1: CREATE TABLE t27463_parent (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27463_child (id INT PRIMARY KEY, pid INT, pad BIT VARYING, FOREIGN KEY (pid) REFERENCES t27463_parent(id) ON DELETE CASCADE);
C1: INSERT INTO t27463_parent VALUES (7,0),(8,0);
C1: INSERT INTO t27463_child VALUES (1, 7, CAST (REPEAT ('ab', 6500) AS BIT VARYING));
C1: INSERT INTO t27463_child VALUES (2, 8, CAST (REPEAT ('ab', 6500) AS BIT VARYING));
C1: UPDATE t27463_child SET pad = CAST (REPEAT ('ab', 8000) AS BIT VARYING) WHERE id = 1;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: SAVEPOINT sp;
MC: wait until C2 ready;
C2: INSERT INTO t27463_child VALUES (9, 7, CAST (REPEAT ('ab', 2000) AS BIT VARYING));
MC: wait until C2 ready;
C1: DELETE FROM t27463_parent WHERE id = 7;
MC: wait until C1 blocked;
C2: ROLLBACK TO SAVEPOINT sp;
MC: wait until C2 ready;
C3: UPDATE t27463_child SET pad = CAST (REPEAT ('ab', 10000) AS BIT VARYING) WHERE id = 2;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 8 */
C1: SELECT id FROM t27463_parent ORDER BY id;
MC: wait until C1 ready;
/* expect 2, 8, 10000 */
C1: SELECT id, pid, OCTET_LENGTH (pad) FROM t27463_child ORDER BY id;
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
C1: DROP TABLE t27463_child;
C1: DROP TABLE t27463_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
