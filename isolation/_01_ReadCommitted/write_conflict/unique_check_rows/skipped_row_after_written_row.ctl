/*
Test Case: unique_check_rows/skipped_row_after_written_row
Priority: 1
Reference case: CBRD-28322 (CUBRID/cubrid#8712)
Author: hgryoo

Test Point:
C2 updates rows 5 and 6 to col = 'abc', which row 1 holds. C1 has deleted row 6 and not committed, so C2 waits for C1. After C1 commits, C2 skips row 6 and writes only row 5, so it checks the unique key as a single-row update and fails with the key value 'abc'. The row it skips comes after the row it writes. Before the fix, C2 checked the key as a multi-row update and reported *UNKNOWN-KEY* (in HA the error was -975).

NUM_CLIENTS = 3
C1: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C1: DELETE FROM t28322_t WHERE id = 6;
C2: UPDATE t28322_t SET col = 'abc' WHERE id IN (5, 6); -- blocks
C1: COMMIT;
C2: (released)
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
C1: DROP TABLE IF EXISTS t28322_t;
C1: CREATE TABLE t28322_t (id INT UNIQUE, col VARCHAR(10) UNIQUE, tag VARCHAR(2));
C1: CREATE UNIQUE INDEX i28322_id_col ON t28322_t (id, col);
C1: INSERT INTO t28322_t VALUES (1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'stu','G');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t28322_t WHERE id = 6;
MC: wait until C1 ready;
C2: UPDATE t28322_t SET col = 'abc' WHERE id IN (5, 6);
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect: C2 fails with the unique key error on 'abc'; rows 1-5 and 7 are left as they were */
C3: SELECT * FROM t28322_t ORDER BY id;
MC: wait until C3 ready;

/* clean up */
C3: commit work;
MC: wait until C3 ready;
C1: DROP TABLE t28322_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
