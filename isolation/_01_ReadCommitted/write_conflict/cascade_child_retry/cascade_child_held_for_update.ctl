/*
Test Case: cascade_child_retry/cascade_child_held_for_update
Priority: 1
Reference case: CBRD-27654 (CUBRID/cubrid#8619)
Author: hgryoo

Test Point:
C3 holds child 2 with SELECT ... FOR UPDATE when C1 deletes the parent (ON DELETE CASCADE), so C1 waits for C3. C2
then updates child 5 and waits for child 2 behind C1. C1 does not hold the children it locked while it waits: C2
updates child 5 at once. When C3 commits, C2 goes on and commits first, and then C1 deletes the parent and both
children, with no deadlock.
Before CBRD-27654 C1 waited for C2 while it held child 2, and C2 waited for C1 on child 2: a deadlock.

NUM_CLIENTS = 3
C3: SELECT x FROM t27654_child WHERE id = 2 FOR UPDATE;
C1: DELETE FROM t27654_parent WHERE id = 7; -- waits on child 2
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 5;
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 2; -- waits on child 2
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
C1: INSERT INTO t27654_child VALUES (2,7,0),(5,7,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: SELECT x FROM t27654_child WHERE id = 2 FOR UPDATE;
MC: wait until C3 ready;
C1: DELETE FROM t27654_parent WHERE id = 7;
MC: wait until C1 blocked;
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 5;
MC: wait until C2 ready;
C2: UPDATE t27654_child SET x = x + 1 WHERE id = 2;
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
