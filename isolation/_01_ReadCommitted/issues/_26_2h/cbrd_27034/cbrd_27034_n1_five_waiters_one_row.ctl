/*
Test Case: cbrd_27034_n1_five_waiters_one_row
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Five transactions queue behind the updater of one row and each is released in turn; all six increments are kept.

NUM_CLIENTS = 6
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C3: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C4: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C5: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C6: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C1: COMMIT;
C2: (released)
C2: COMMIT;
C3: (released)
C3: COMMIT;
C4: (released)
C4: COMMIT;
C5: (released)
C5: COMMIT;
C6: (released)
C6: COMMIT;
*/

MC: setup NUM_CLIENTS = 6;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C4: login as 'dba';
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;
C5: login as 'dba';
C5: set transaction lock timeout INFINITE;
C5: set transaction isolation level read committed;
C6: login as 'dba';
C6: set transaction lock timeout INFINITE;
C6: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C3: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C3 blocked;
C4: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C4 blocked;
C5: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C5 blocked;
C6: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C6 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
MC: wait until C4 ready;
C4: COMMIT;
MC: wait until C4 ready;
MC: wait until C5 ready;
C5: COMMIT;
MC: wait until C5 ready;
MC: wait until C6 ready;
C6: COMMIT;
MC: wait until C6 ready;

/* expected end state */
/* expect 6 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 6 */
C1: SELECT SUM(v) FROM t27034_t;
MC: wait until C1 ready;
/* expect 2 */
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
C4: rollback work;
MC: wait until C4 ready;
C5: rollback work;
MC: wait until C5 ready;
C6: rollback work;
MC: wait until C6 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
C5: quit;
C6: quit;
