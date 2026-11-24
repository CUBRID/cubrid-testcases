/*
Test Case: trigger/dml_ddl/trigger_action_insert_target_gains_trigger
Priority: 1
Reference case: CBRD-27752 (CUBRID/cubrid#8636)
Author: hgryoo

Test Point:
An INSERT in a trigger action runs on the server while its target table has no INSERT trigger. When the target gains one, the INSERT must run on the client again so that the new trigger fires: first when another transaction creates the trigger, then when the same transaction replaces it.

NUM_CLIENTS = 2
C1: INSERT INTO t27752_p VALUES (1); -- its trigger action inserts into t27752_ch, which has no trigger
C2: CREATE TRIGGER trg27752_ch AFTER INSERT ON t27752_ch ...; COMMIT;
C1: INSERT INTO t27752_p VALUES (2); -- trg27752_ch fires
C1: DROP TRIGGER trg27752_ch; CREATE TRIGGER trg27752_ch2 ...;
C1: INSERT INTO t27752_p VALUES (3); -- trg27752_ch2 fires
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27752_audit;
C1: DROP TABLE IF EXISTS t27752_ch;
C1: DROP TABLE IF EXISTS t27752_p;
C1: CREATE TABLE t27752_p (id INT PRIMARY KEY);
C1: CREATE TABLE t27752_ch (cid INT AUTO_INCREMENT PRIMARY KEY, pid INT);
C1: CREATE TABLE t27752_audit (id INT AUTO_INCREMENT PRIMARY KEY, pid INT);
C1: CREATE TRIGGER trg27752_p AFTER INSERT ON t27752_p EXECUTE INSERT INTO t27752_ch (pid) VALUES (obj.id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: INSERT INTO t27752_p VALUES (1);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: CREATE TRIGGER trg27752_ch AFTER INSERT ON t27752_ch EXECUTE INSERT INTO t27752_audit (pid) VALUES (obj.pid);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: INSERT INTO t27752_p VALUES (2);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C1: DROP TRIGGER trg27752_ch;
MC: wait until C1 ready;
C1: CREATE TRIGGER trg27752_ch2 AFTER INSERT ON t27752_ch EXECUTE INSERT INTO t27752_audit (pid) VALUES (obj.pid + 100);
MC: wait until C1 ready;
C1: INSERT INTO t27752_p VALUES (3);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect children of 1, 2 and 3 */
C1: SELECT pid FROM t27752_ch ORDER BY pid;
MC: wait until C1 ready;
/* expect 2 and 103: the trigger of C2 fired for 2, the trigger of C1 for 3, none for 1 */
C1: SELECT pid FROM t27752_audit ORDER BY pid;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TRIGGER trg27752_ch2;
C1: DROP TRIGGER trg27752_p;
C1: DROP TABLE t27752_audit;
C1: DROP TABLE t27752_ch;
C1: DROP TABLE t27752_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
