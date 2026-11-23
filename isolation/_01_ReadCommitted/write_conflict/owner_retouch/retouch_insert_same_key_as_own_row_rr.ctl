/*
Test Case: owner_retouch/retouch_insert_same_key_as_own_row_rr
Priority: 1
Reference case: CBRD-27752 (CUBRID/cubrid#8636)
Author: hgryoo

Test Point:
The same as retouch_insert_same_key_as_own_row at REPEATABLE READ, where the UPDATE keeps its row lock to commit: the waiting transaction waits for the row lock, the INSERT of the transaction that holds it ends with a unique key violation, and no deadlock. When the holder commits, the UPDATE of the waiting transaction fails, because the row changed after its snapshot. At this isolation level the UPDATE does not give its row lock back at the end of the statement, so the unique key check that the fix changes never meets a row of its own transaction whose lock a waiter holds: this is a control.

NUM_CLIENTS = 2
C1: UPDATE t27752_t SET v=v+1 WHERE id=1;
C2: UPDATE t27752_t SET v=v+10 WHERE id=1; -- blocks
C1: INSERT INTO t27752_t VALUES (1, 0); -- unique key violation
C1: COMMIT;
C2: (released, fails)
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t27752_t;
C1: CREATE TABLE t27752_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27752_t VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27752_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27752_t SET v=v+10 WHERE id=1;
MC: wait until C2 blocked;
C1: INSERT INTO t27752_t VALUES (1, 0);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 1) and (2, 0) */
C1: SELECT id, v FROM t27752_t ORDER BY id;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot (the shell case cbrd_27752 does) */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27752_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
