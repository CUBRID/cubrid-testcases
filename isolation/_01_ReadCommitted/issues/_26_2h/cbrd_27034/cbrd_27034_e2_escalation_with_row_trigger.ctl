/*
Test Case: cbrd_27034_e2_escalation_with_row_trigger
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A DELETE on a table with a row trigger runs on the client and keeps its locks to commit: a concurrent INSERT waits until the DELETE rolls back.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: DELETE FROM t27034_t WHERE id <= 200;
C2: INSERT INTO t27034_t VALUES (999999, 0); -- blocks
C1: ROLLBACK;
C2: (released)
C2: ROLLBACK;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_aud;
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27034_aud (id INT AUTO_INCREMENT PRIMARY KEY, who INT);
C1: INSERT INTO t27034_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: CREATE TRIGGER t27034_trg_del AFTER DELETE ON t27034_t EXECUTE INSERT INTO t27034_aud (who) VALUES (1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: DELETE FROM t27034_t WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27034_t VALUES (999999, 0);
MC: wait until C2 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: ROLLBACK;
MC: wait until C2 ready;

/* expected end state */
/* expect 300 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_aud;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_t WHERE id=999999;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TRIGGER t27034_trg_del;
C1: DROP TABLE t27034_aud;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
