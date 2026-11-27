/*
Test Case: unique_fk_check/child_insert_times_out_on_deleting_parent
Priority: 1
Reference case: CBRD-27710 (CUBRID/cubrid#8629)
Author: zionyun

Test Point:
Another transaction deletes a parent row and does not commit. A child INSERT that refers to that parent waits for the transaction lock of the deleter, and times out at once with a lock timeout of 0.
The timeout message names the parent row and the parent table, with S_LOCK in parentheses as the mode the INSERT wants on the parent: the foreign key check of an INSERT reads the parent under S, it does not change it.
The other cases of CBRD-27710 name a child row, or a row under X_LOCK; this one is the only wait on a parent row under S_LOCK.

NUM_CLIENTS = 2
C1: DELETE FROM t27710_p WHERE id = 1;
C2: INSERT INTO t27710_c VALUES (10, 1); -- waits for C1's transaction and times out at once
C2: rollback work;
C1: rollback work;
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
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27710_p WHERE id = 1;
MC: wait until C1 ready;
C2: set transaction lock timeout 0;
MC: wait until C2 ready;
/* expect a timeout on S_LOCK of the parent row of t27710_p */
C2: INSERT INTO t27710_c VALUES (10, 1);
MC: wait until C2 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: rollback work;
MC: wait until C1 ready;

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
