/*
Test Case: unique_check_rows/recompute_assignment
Priority: 1
Reference case: CBRD-28322 (CUBRID/cubrid#8712)
Author: hgryoo

Test Point:
C2 assigns a unique column from a column that C1 changes. C1 has changed tag of row 5 to 'Q' and not committed. C2 waits for C1 and then computes the new value from the version C1 committed, so row 5 gets 'Q_mno', not 'E_mno'. The result is the same before and after the fix.

NUM_CLIENTS = 3
C1: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C1: UPDATE t28322_t SET tag = 'Q' WHERE id = 5;
C2: UPDATE t28322_t SET col = tag || '_' || col WHERE id IN (5, 6); -- blocks
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
C1: UPDATE t28322_t SET tag = 'Q' WHERE id = 5;
MC: wait until C1 ready;
C2: UPDATE t28322_t SET col = tag || '_' || col WHERE id IN (5, 6);
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect: 2 rows updated: row 5 has col 'Q_mno', row 6 has col 'F_pqr' */
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
