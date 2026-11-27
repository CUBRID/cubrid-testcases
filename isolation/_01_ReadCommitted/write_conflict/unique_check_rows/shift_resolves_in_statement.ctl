/*
Test Case: unique_check_rows/shift_resolves_in_statement
Priority: 1
Reference case: CBRD-28322 (CUBRID/cubrid#8712)
Author: hgryoo

Test Point:
C2 adds 1 to id of rows 5, 6 and 7 with no other writer. Row 5 takes id 6 while row 6 still holds it, and the same statement then moves row 6 to 7 and row 7 to 8, so the keys are unique when the statement ends and the update succeeds. The result is the same before and after the fix.

NUM_CLIENTS = 3
C1: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: UPDATE t28322_t SET id = id + 1 WHERE id >= 5;
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
C2: UPDATE t28322_t SET id = id + 1 WHERE id >= 5;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect: 3 rows updated: ids 1-4, 6, 7 and 8 */
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
