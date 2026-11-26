/*
Test Case: owner_retouch/retouch_update_moves_key_onto_own_row
Priority: 1
Reference case: CBRD-27752 (CUBRID/cubrid#8636)
Author: hgryoo

Test Point:
A transaction runs UPDATE t SET id = id + 1, which moves the key of row 1 onto the key of row 2, a row it updated in an earlier statement, while another transaction waits for row 2: no deadlock, and the keys become 2 and 3.
The unique key check of the moved key passes row 2 of its own transaction instead of locking it. Without the fix the check waits behind the waiting transaction: a deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27752_t SET v=v+1 WHERE id=2;
C2: UPDATE t27752_t SET v=v+10 WHERE id=2; -- blocks
C1: UPDATE t27752_t SET id=id+1;
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
C1: UPDATE t27752_t SET v=v+1 WHERE id=2;
MC: wait until C1 ready;
C2: UPDATE t27752_t SET v=v+10 WHERE id=2;
MC: wait until C2 blocked;
C1: UPDATE t27752_t SET id=id+1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect keys 2 and 3: the old row 1 with v 0 and the old row 2 with v 1 */
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
