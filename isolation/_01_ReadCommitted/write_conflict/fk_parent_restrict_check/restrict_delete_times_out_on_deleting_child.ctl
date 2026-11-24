/*
Test Case: fk_parent_restrict_check/restrict_delete_times_out_on_deleting_child
Priority: 1
Reference case: CBRD-27710 (CUBRID/cubrid#8629)
Author: hgryoo

Test Point:
The foreign key is RESTRICT. Another transaction deletes the only child of the parent row and does not commit, and the parent DELETE times out waiting for that transaction.
The timeout message names the child row and the child table, with S_LOCK in parentheses as the mode the DELETE wants on the child: the restrict check reads the child under S, it does not change it.
A lock timeout of 0 makes the DELETE time out at once.

NUM_CLIENTS = 2
C2: DELETE FROM t27710_c WHERE cid = 10;
C1: DELETE FROM t27710_p WHERE id = 1; -- waits for C2's transaction and times out at once
C1: rollback work;
C2: commit work;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27710_c;
C1: DROP TABLE IF EXISTS t27710_p;
C1: CREATE TABLE t27710_p (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27710_c (cid INT PRIMARY KEY, pid INT, CONSTRAINT fk_t27710_c FOREIGN KEY (pid) REFERENCES t27710_p (id));
C1: INSERT INTO t27710_p VALUES (1, 0), (2, 0);
C1: INSERT INTO t27710_c VALUES (10, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: DELETE FROM t27710_c WHERE cid = 10;
MC: wait until C2 ready;
C1: set transaction lock timeout 0;
MC: wait until C1 ready;
/* expect a timeout on S_LOCK of the child row of t27710_c */
C1: DELETE FROM t27710_p WHERE id = 1;
MC: wait until C1 ready;
C1: rollback work;
MC: wait until C1 ready;
C2: commit work;
MC: wait until C2 ready;

/* expected end state */
C1: SELECT id, v FROM t27710_p ORDER BY id;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27710_c;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27710_c;
C1: DROP TABLE t27710_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
