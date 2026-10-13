/*
Test Case: cbrd_27034_n5_three_cycle_deadlock
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Three transactions form a cycle over three rows; the deadlock detector ends one and the other two complete.

NUM_CLIENTS = 3
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C1: UPDATE t27034_t SET v=7 WHERE id=7;
C2: UPDATE t27034_t SET v=v+1 WHERE id=2;
C2: UPDATE t27034_t SET v=8 WHERE id=8;
C3: UPDATE t27034_t SET v=v+1 WHERE id=3;
C1: UPDATE t27034_t SET v=v+1 WHERE id=2; -- blocks
C2: UPDATE t27034_t SET v=v+1 WHERE id=3; -- blocks
C3: UPDATE t27034_t SET v=v+1 WHERE id=1; -- fails
C2: (released)
C2: COMMIT;
C1: (released)
C1: COMMIT;
C3: COMMIT;
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t VALUES (1,0),(2,0),(3,0),(7,0),(8,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C1: UPDATE t27034_t SET v=7 WHERE id=7;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=2;
MC: wait until C2 ready;
C2: UPDATE t27034_t SET v=8 WHERE id=8;
MC: wait until C2 ready;
C3: UPDATE t27034_t SET v=v+1 WHERE id=3;
MC: wait until C3 ready;
C1: UPDATE t27034_t SET v=v+1 WHERE id=2;
MC: wait until C1 blocked;
C2: UPDATE t27034_t SET v=v+1 WHERE id=3;
MC: wait until C2 blocked;
C3: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C3 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=3;
MC: wait until C1 ready;
/* expect 7 */
C1: SELECT v FROM t27034_t WHERE id=7;
MC: wait until C1 ready;
/* expect 8 */
C1: SELECT v FROM t27034_t WHERE id=8;
MC: wait until C1 ready;
/* expect 19 */
C1: SELECT SUM(v) FROM t27034_t;
MC: wait until C1 ready;
/* expect 5 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
