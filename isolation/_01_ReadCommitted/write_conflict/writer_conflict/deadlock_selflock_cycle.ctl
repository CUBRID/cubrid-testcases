/*
Test Case: writer_conflict/deadlock_selflock_cycle
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Two transactions update two rows in opposite order; the deadlock detector ends one and the other's changes are kept.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+1 WHERE id=2;
C2: UPDATE t27034_t SET v=7 WHERE id=9;
C1: UPDATE t27034_t SET v=v+1 WHERE id=2; -- blocks
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
C1: (released, fails)
C2: COMMIT;
C1: COMMIT;
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
C1: INSERT INTO t27034_t VALUES (1,0),(2,0),(9,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=2;
MC: wait until C2 ready;
C2: UPDATE t27034_t SET v=7 WHERE id=9;
MC: wait until C2 ready;
C1: UPDATE t27034_t SET v=v+1 WHERE id=2;
MC: wait until C1 blocked;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C2 ready;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C2: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 7 */
C2: SELECT v FROM t27034_t WHERE id=9;
MC: wait until C2 ready;
/* expect 9 */
C2: SELECT SUM(v) FROM t27034_t;
MC: wait until C2 ready;
/* expect 3 */
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
