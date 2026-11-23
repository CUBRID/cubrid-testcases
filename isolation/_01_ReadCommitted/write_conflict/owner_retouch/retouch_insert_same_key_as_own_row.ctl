/*
Test Case: owner_retouch/retouch_insert_same_key_as_own_row
Priority: 1
Reference case: CBRD-27752 (CUBRID/cubrid#8636)
Author: hgryoo

Test Point:
A transaction inserts the key of a row that it updated in an earlier statement, while another transaction waits for that row: the INSERT ends with a unique key violation, and no deadlock.
The UPDATE gives the row lock back when the statement ends. The unique key check of the INSERT passes the row of its own transaction instead of locking it. Without the fix the check waits behind the waiting transaction: a deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27752_t SET v=v+1 WHERE id=1;
C2: UPDATE t27752_t SET v=v+10 WHERE id=1; -- blocks
C1: INSERT INTO t27752_t VALUES (1, 0); -- unique key violation
C1: COMMIT;
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
/* expect (1, 11) and (2, 0) */
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
