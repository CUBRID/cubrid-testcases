/*
Test Case: odku_replace/odku_waiter_owner_rolls_back
Priority: 1
Reference case: CBRD-27709 (CUBRID/cubrid#8599)
Author: hgryoo

Test Point:
INSERT ... ON DUPLICATE KEY UPDATE waits for the owner of the duplicate row, which moves the row to another key and then rolls back. Every change of the owner is undone, so the last version of the row is the committed original, which the waiter settles on and keeps without asking the key again (debug builds ask it again and assert that it names the same row). The ODKU updates row 1 and leaves row 2 alone.

NUM_CLIENTS = 2
C1: UPDATE t27709_t SET v=v+5 WHERE id=1;
C2: INSERT INTO t27709_t VALUES (1, 100) ON DUPLICATE KEY UPDATE v=v+1; -- blocks
C1: UPDATE t27709_t SET id=5 WHERE id=1;
C1: ROLLBACK;
C2: (released)
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27709_t;
C1: CREATE TABLE t27709_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27709_t VALUES (1,10),(2,20);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27709_t SET v=v+5 WHERE id=1;
MC: wait until C1 ready;
C2: INSERT INTO t27709_t VALUES (1, 100) ON DUPLICATE KEY UPDATE v=v+1;
MC: wait until C2 blocked;
C1: UPDATE t27709_t SET id=5 WHERE id=1;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 11), (2, 20) */
C1: SELECT id, v FROM t27709_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27709_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
