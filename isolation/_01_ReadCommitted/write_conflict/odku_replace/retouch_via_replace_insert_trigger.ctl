/*
Test Case: odku_replace/retouch_via_replace_insert_trigger
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
On a table with an INSERT trigger, where REPLACE runs on the client, a transaction hits a row it updated earlier with REPLACE while another transaction waits for it: no deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C1: REPLACE INTO t27034_t VALUES (1, 100);
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
C1: DROP TABLE IF EXISTS t27034_audit_t;
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27034_audit_t (id INT AUTO_INCREMENT PRIMARY KEY, who INT);
C1: INSERT INTO t27034_t VALUES (1,0),(2,0);
C1: CREATE TRIGGER t27034_trg_ins AFTER INSERT ON t27034_t EXECUTE INSERT INTO t27034_audit_t (who) VALUES (obj.id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C1: REPLACE INTO t27034_t VALUES (1, 100);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 100 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_audit_t;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TRIGGER t27034_trg_ins;
C1: DROP TABLE t27034_audit_t;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
