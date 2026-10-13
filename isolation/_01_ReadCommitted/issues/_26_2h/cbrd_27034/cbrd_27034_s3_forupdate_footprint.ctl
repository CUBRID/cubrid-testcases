/*
Test Case: cbrd_27034_s3_forupdate_footprint
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
While 200 rows are held by SELECT ... FOR UPDATE, another session's snapshot read does not wait.

NUM_CLIENTS = 2
C1: SELECT id FROM t27034_t WHERE id <= 200 FOR UPDATE;
C2: SELECT COUNT(*) FROM t27034_t;
C1: ROLLBACK;
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SELECT id FROM t27034_t WHERE id <= 200 FOR UPDATE;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 300 */
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
