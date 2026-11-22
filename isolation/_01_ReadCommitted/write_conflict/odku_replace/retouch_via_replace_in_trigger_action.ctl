/*
Test Case: odku_replace/retouch_via_replace_in_trigger_action
Priority: 1
Reference case: CBRD-27752 (CUBRID/cubrid#8636)
Author: hgryoo

Test Point:
A trigger action of another table runs REPLACE on a row that its transaction updated in an earlier statement, while another transaction waits for that row: no deadlock.
The table of the row has no trigger, so its UPDATE gives the row lock back when the statement ends. The REPLACE in the trigger action runs on the server, which passes a row of its own transaction instead of locking it. Without the fix it runs on the client and waits behind the waiting transaction: a deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27752_t SET v=v+1 WHERE id=1;
C2: UPDATE t27752_t SET v=v+10 WHERE id=1; -- blocks
C1: INSERT INTO t27752_s VALUES (1); -- its trigger action: REPLACE INTO t27752_t VALUES (obj.id, 100)
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
C1: DROP TABLE IF EXISTS t27752_s;
C1: DROP TABLE IF EXISTS t27752_t;
C1: CREATE TABLE t27752_t (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27752_s (id INT);
C1: INSERT INTO t27752_t VALUES (1,0),(2,0);
C1: CREATE TRIGGER trg27752_s AFTER INSERT ON t27752_s EXECUTE REPLACE INTO t27752_t VALUES (obj.id, 100);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27752_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27752_t SET v=v+10 WHERE id=1;
MC: wait until C2 blocked;
C1: INSERT INTO t27752_s VALUES (1);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (1, 100) and (2, 0): the REPLACE deletes the row C2 waits for, so the UPDATE of C2 finds no row */
C1: SELECT id, v FROM t27752_t ORDER BY id;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot (the shell case cbrd_27752 does) */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TRIGGER trg27752_s;
C1: DROP TABLE t27752_s;
C1: DROP TABLE t27752_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
