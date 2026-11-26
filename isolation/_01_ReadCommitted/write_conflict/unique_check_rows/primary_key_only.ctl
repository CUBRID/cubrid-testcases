/*
Test Case: unique_check_rows/primary_key_only
Priority: 1
Reference case: CBRD-28322 (CUBRID/cubrid#8712)
Author: hgryoo

Test Point:
The table has only a primary key. C1 has deleted row 2 and not committed. C2 waits for C1, then skips row 2 and writes only row 5, so it checks the primary key as a single-row update and fails with the key value 1. Before the fix, C2 reported *UNKNOWN-KEY* (in HA the error was -975).

NUM_CLIENTS = 3
C1: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C1: DELETE FROM t28322_pk WHERE id = 2;
C2: UPDATE t28322_pk SET id = 1 WHERE tag = 'E' OR tag = 'B'; -- blocks
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
C1: DROP TABLE IF EXISTS t28322_pk;
C1: CREATE TABLE t28322_pk (id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t28322_pk VALUES (1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'stu','G');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t28322_pk WHERE id = 2;
MC: wait until C1 ready;
C2: UPDATE t28322_pk SET id = 1 WHERE tag = 'E' OR tag = 'B';
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect: C2 fails with the primary key error on 1; rows 1 and 3-7 are left as they were */
C3: SELECT * FROM t28322_pk ORDER BY id;
MC: wait until C3 ready;

/* clean up */
C3: commit work;
MC: wait until C3 ready;
C1: DROP TABLE t28322_pk;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
