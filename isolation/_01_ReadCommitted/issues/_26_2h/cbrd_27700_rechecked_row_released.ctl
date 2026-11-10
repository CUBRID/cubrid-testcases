/*
Test Case: cbrd_27700_rechecked_row_released
Priority: 1
Reference case: CBRD-27700 (CUBRID/cubrid#8463)
Author: hgryoo

Test Point:
When the client-side DELETE skips a row that failed the re-check, it gives back the lock it took on that row. Another transaction can update the row before the DELETE commits.

NUM_CLIENTS = 3
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
C2: DELETE FROM t27700_t WHERE k < 50;  -- waits for C1, then skips row 2
C1: COMMIT;
C3: UPDATE t27700_t SET k = 98 WHERE id = 2;  -- C2 has not committed; row 2 is not locked by C2
C3: COMMIT;
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
C1: DROP VIEW IF EXISTS t27700_v;
C1: DROP VIEW IF EXISTS t27700_v2;
C1: DROP TABLE IF EXISTS t27700_t;
C1: DROP TABLE IF EXISTS t27700_u;
C1: DROP TABLE IF EXISTS t27700_x;
C1: DROP TABLE IF EXISTS t27700_audit;
C1: CREATE TABLE t27700_t (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t27700_audit (seq INT AUTO_INCREMENT PRIMARY KEY, who INT);
C1: INSERT INTO t27700_t VALUES (1, 10), (2, 20), (3, 30);
C1: CREATE TRIGGER t27700_trg AFTER DELETE ON t27700_t EXECUTE INSERT INTO t27700_audit (who) VALUES (0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27700_t SET k = 99 WHERE id = 2;
MC: wait until C1 ready;
C2: DELETE FROM t27700_t WHERE k < 50;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
/* C2 has not committed yet; it gave back the lock on row 2 when row 2 failed the re-check */
C3: UPDATE t27700_t SET k = 98 WHERE id = 2;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect (2, 98) only */
C1: SELECT id, k FROM t27700_t ORDER BY id;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27700_audit;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP VIEW IF EXISTS t27700_v;
C1: DROP VIEW IF EXISTS t27700_v2;
C1: DROP TABLE IF EXISTS t27700_t;
C1: DROP TABLE IF EXISTS t27700_u;
C1: DROP TABLE IF EXISTS t27700_x;
C1: DROP TABLE IF EXISTS t27700_audit;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
