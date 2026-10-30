/*
Test Case: writer_conflict/bigone_overflow_row
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Two transactions update the same overflow row: the second waits, both increments are kept and the large value is intact.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C1: COMMIT;
C2: (released)
C2: SELECT id, LENGTH(big), v FROM t27034_t ORDER BY id;
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
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, big VARCHAR(30000), v INT);
C1: INSERT INTO t27034_t VALUES (1, REPEAT('x', 20000), 0);
C1: INSERT INTO t27034_t VALUES (2, 'small', 0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, LENGTH(big), v FROM t27034_t ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 2 */
C2: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
/* expect 20000 */
C2: SELECT CHAR_LENGTH(big) FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
/* expect 0 */
C2: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 5 */
C2: SELECT CHAR_LENGTH(big) FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 2 */
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

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
