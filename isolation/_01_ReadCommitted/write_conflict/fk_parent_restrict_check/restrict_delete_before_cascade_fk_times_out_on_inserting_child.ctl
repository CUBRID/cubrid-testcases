/*
Test Case: fk_parent_restrict_check/restrict_delete_before_cascade_fk_times_out_on_inserting_child
Priority: 1
Reference case: CBRD-27710 (CUBRID/cubrid#8629)
Author: zionyun

Test Point:
The parent key has two foreign keys: a RESTRICT one from t27710_r, declared first, and an ON DELETE CASCADE one from t27710_a. The CASCADE child is committed; another transaction inserts a RESTRICT child and does not commit.
The parent DELETE times out waiting for the inserter of the RESTRICT child, and the mode in parentheses in the timeout message is S_LOCK, with the child row of t27710_r.
This is restrict_delete_after_cascade_fk_times_out_on_inserting_child with the two foreign keys declared in the other order. There the RESTRICT foreign key comes last, so a mode that the last foreign key sets for all of them would still show S_LOCK; here the CASCADE foreign key comes last, and such a mode would show X_LOCK.
A lock timeout of 0 makes the DELETE time out at once.

NUM_CLIENTS = 2
C2: INSERT INTO t27710_r VALUES (20, 1);
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
C1: DROP TABLE IF EXISTS t27710_a;
C1: DROP TABLE IF EXISTS t27710_r;
C1: DROP TABLE IF EXISTS t27710_p;
C1: CREATE TABLE t27710_p (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27710_r (cid INT PRIMARY KEY, pid INT, CONSTRAINT fk_t27710_r FOREIGN KEY (pid) REFERENCES t27710_p (id));
C1: CREATE TABLE t27710_a (cid INT PRIMARY KEY, pid INT, CONSTRAINT fk_t27710_a FOREIGN KEY (pid) REFERENCES t27710_p (id) ON DELETE CASCADE);
C1: INSERT INTO t27710_p VALUES (1, 0), (2, 0);
C1: INSERT INTO t27710_a VALUES (10, 1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: INSERT INTO t27710_r VALUES (20, 1);
MC: wait until C2 ready;
C1: set transaction lock timeout 0;
MC: wait until C1 ready;
/* expect a timeout on S_LOCK of the child row of t27710_r */
C1: DELETE FROM t27710_p WHERE id = 1;
MC: wait until C1 ready;
C1: rollback work;
MC: wait until C1 ready;
C2: commit work;
MC: wait until C2 ready;

/* expected end state */
C1: SELECT id, v FROM t27710_p ORDER BY id;
MC: wait until C1 ready;
C1: SELECT cid, pid FROM t27710_a ORDER BY cid;
MC: wait until C1 ready;
C1: SELECT cid, pid FROM t27710_r ORDER BY cid;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27710_a;
C1: DROP TABLE t27710_r;
C1: DROP TABLE t27710_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
