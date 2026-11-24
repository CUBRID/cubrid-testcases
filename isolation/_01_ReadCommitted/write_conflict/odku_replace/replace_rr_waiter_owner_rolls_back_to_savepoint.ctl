/*
Test Case: odku_replace/replace_rr_waiter_owner_rolls_back_to_savepoint
Priority: 1
Reference case: CBRD-27709 (CUBRID/cubrid#8599)
Author: hgryoo

Test Point:
Under REPEATABLE READ, REPLACE waits for the owner of the duplicate row, which moves the row to another key and then rolls back to a savepoint taken before its first change, and commits. Every change of the owner is undone, so the last version of the row is the committed original, which the waiter settles on and keeps without asking the key again (debug builds ask it again and assert that it names the same row). The REPLACE deletes row 1, inserts (1, 100) and leaves row 2 alone. A third client reads the end state.

NUM_CLIENTS = 3
C1: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
C1: SAVEPOINT sp1;
C1: UPDATE t27709_t SET v=v+5 WHERE id=1;
C2: REPLACE INTO t27709_t VALUES (1, 100); -- blocks
C1: UPDATE t27709_t SET id=5 WHERE id=1;
C1: ROLLBACK TO SAVEPOINT sp1;
C1: COMMIT;
C2: (released)
C2: COMMIT;
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
C1: DROP TABLE IF EXISTS t27709_t;
C1: CREATE TABLE t27709_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27709_t VALUES (1,10),(2,20);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
MC: wait until C1 ready;
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
MC: wait until C2 ready;
C1: SAVEPOINT sp1;
MC: wait until C1 ready;
C1: UPDATE t27709_t SET v=v+5 WHERE id=1;
MC: wait until C1 ready;
C2: REPLACE INTO t27709_t VALUES (1, 100);
MC: wait until C2 blocked;
C1: UPDATE t27709_t SET id=5 WHERE id=1;
MC: wait until C1 ready;
C1: ROLLBACK TO SAVEPOINT sp1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 100), (2, 20) */
C3: SELECT id, v FROM t27709_t ORDER BY id;
MC: wait until C3 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27709_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
