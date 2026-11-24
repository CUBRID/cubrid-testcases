/*
Test Case: cascade_child_retry/cascade_child_held_many_batches
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
The schedule of cascade_child_held_for_update with 20000 children: the cascade keeps more children than it holds in
memory, so it keeps the earlier ones in a list file. C3 holds child 19999, the last one. While C1 waits for C3 it
holds none of the children it locked before, so C2 updates child 1 at once. When C3 commits, C2 and then C1 end,
with no deadlock.
Before CBRD-27654 C1 waited while it held the earlier children, and C2 waited for C1 on child 1.

NUM_CLIENTS = 3
C3: SELECT x FROM t27654_child WHERE id = 19999 FOR UPDATE;
C1: DELETE FROM t27654_parent WHERE id = 7; -- waits on child 19999
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 1;
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 19999; -- waits on child 19999
C3: COMMIT;
C2: (goes on)
C2: COMMIT;
C1: (goes on)
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
C1: DROP TABLE IF EXISTS t27654_child;
C1: DROP TABLE IF EXISTS t27654_parent;
C1: CREATE TABLE t27654_parent (id INT PRIMARY KEY);
C1: CREATE TABLE t27654_child (id INT PRIMARY KEY, pid INT, x INT, FOREIGN KEY (pid) REFERENCES t27654_parent (id) ON DELETE CASCADE);
C1: INSERT INTO t27654_parent VALUES (7);
C1: INSERT INTO t27654_child SELECT ROWNUM, 7, 0 FROM db_class a, db_class b, db_class c LIMIT 20000;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: SELECT x FROM t27654_child WHERE id = 19999 FOR UPDATE;
MC: wait until C3 ready;
C1: DELETE FROM t27654_parent WHERE id = 7;
MC: wait until C1 blocked;
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 1;
MC: wait until C2 ready;
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 19999;
MC: wait until C2 blocked;
C3: COMMIT;
MC: wait until C3 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27654_parent;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27654_child;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27654_child;
C1: DROP TABLE t27654_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
