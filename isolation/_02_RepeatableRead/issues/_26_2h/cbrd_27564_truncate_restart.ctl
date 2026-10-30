/*
Test Case: related to CBRD-27564
Priority: 1

Test Plan:
TRUNCATE restarts the AUTO_INCREMENT serial of the table. At REPEATABLE READ the client wrote the
serial row before it marked the write as a restart, so the server kept the old value and the next
INSERT continued after the last id. ALTER SERIAL ... START WITH and ALTER TABLE ... AUTO_INCREMENT =
take the same path and are covered by serial/alterserial_* and dml_ddl/altertable_update_01.

Test Point:
1) An INSERT after TRUNCATE in the same transaction gets id 1.
2) After that transaction commits, an INSERT from another client gets id 2.
3) When TRUNCATE commits in its own transaction, the INSERT of the next transaction gets id 1.

NUM_CLIENTS = 2
C1: TRUNCATE and INSERT in one transaction
C2: INSERT after C1 commits; then TRUNCATE, commit, INSERT
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS ai27564;
C1: CREATE TABLE ai27564 (id INT AUTO_INCREMENT PRIMARY KEY, v INT);
C1: INSERT INTO ai27564 (v) VALUES (1), (2), (3);
C1: commit work;
MC: wait until C1 ready;

/* test case: TRUNCATE and INSERT in one transaction */
C1: TRUNCATE TABLE ai27564;
C1: INSERT INTO ai27564 (v) VALUES (4);
C1: SELECT * FROM ai27564 ORDER BY id;
C1: commit work;
MC: wait until C1 ready;

/* the restart is committed: C2 continues from it */
C2: INSERT INTO ai27564 (v) VALUES (5);
C2: SELECT * FROM ai27564 ORDER BY id;
C2: commit work;
MC: wait until C2 ready;

/* TRUNCATE and INSERT in separate transactions */
C2: TRUNCATE TABLE ai27564;
C2: commit work;
C2: INSERT INTO ai27564 (v) VALUES (6);
C2: SELECT * FROM ai27564 ORDER BY id;
C2: commit work;
MC: wait until C2 ready;

/* cleanup */
C1: DROP TABLE ai27564;
C1: commit work;
MC: wait until C1 ready;

C2: quit;
C1: quit;
