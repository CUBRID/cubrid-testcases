/*
Test Case: repeatable_read_release/rr_manual_locking_example
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
The REPEATABLE READ locking example of the manual (Examples using locks): T1 changes the primary key of a row,
T2 reads the old version, then tries to update it and waits for T1.  After T1 commits, T2 gets the serialization
error.  The row lock of T1 goes back when its UPDATE ends; T2 waits on T1's transaction lock instead.

NUM_CLIENTS = 2
C1: UPDATE t28025_tbl SET a = 90 WHERE a = 10;
C2: SELECT a, b FROM t28025_tbl WHERE a <= 20 ORDER BY a; -- C2 still sees the row a = 10
C2: UPDATE t28025_tbl SET a = a + 100 WHERE a <= 20; -- C2 waits for C1 to end
C1: COMMIT;
C2: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t28025_tbl;
C1: CREATE TABLE t28025_tbl (a INT PRIMARY KEY, b INT);
C1: INSERT INTO t28025_tbl VALUES (10, 10), (30, 30), (50, 50), (70, 70);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t28025_tbl SET a = 90 WHERE a = 10;
MC: wait until C1 ready;
/* C2 still sees the row a = 10 */
C2: SELECT a, b FROM t28025_tbl WHERE a <= 20 ORDER BY a;
MC: wait until C2 ready;
/* C2 waits for C1 to end */
C2: UPDATE t28025_tbl SET a = a + 100 WHERE a <= 20;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 30 30, 50 50, 70 70, 90 10 */
C1: SELECT a, b FROM t28025_tbl ORDER BY a;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t28025_tbl;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
