/*
Test Case: writer_conflict/second_waiter_timeout_names_owner
Priority: 1
Reference case: CBRD-27710 (CUBRID/cubrid#8629)
Author: zionyun

Test Point:
C1 updates a row and does not commit. C2 updates the same row and waits for the transaction lock of C1, holding the X lock of the row. C3 updates the same row with a lock timeout of 0 and times out at once on the row lock that C2 holds.
The timeout message of C3 names two users: C2, which holds the row lock, and C1, which owns the row and which C2 waits for. Before CBRD-27710 it named C2 alone.
A lock timeout of 0 makes the UPDATE of C3 time out at once; C2 keeps waiting and goes on once C1 commits.

NUM_CLIENTS = 3
C1: UPDATE t27710_t SET v = v + 1 WHERE id = 1;
C2: UPDATE t27710_t SET v = v + 1 WHERE id = 1; -- blocks on the transaction lock of C1
C3: UPDATE t27710_t SET v = v + 1 WHERE id = 1; -- times out at once, naming C2 and C1
C3: rollback work;
C1: commit work;
C2: (released)
C2: commit work;
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
C1: DROP TABLE IF EXISTS t27710_t;
C1: CREATE TABLE t27710_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27710_t VALUES (1, 0), (2, 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27710_t SET v = v + 1 WHERE id = 1;
MC: wait until C1 ready;
C2: UPDATE t27710_t SET v = v + 1 WHERE id = 1;
MC: wait until C2 blocked;
C3: set transaction lock timeout 0;
MC: wait until C3 ready;
/* expect a timeout on X_LOCK of the row that names two users */
C3: UPDATE t27710_t SET v = v + 1 WHERE id = 1;
MC: wait until C3 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: commit work;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: commit work;
MC: wait until C2 ready;

/* expected end state */
C1: SELECT id, v FROM t27710_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27710_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
