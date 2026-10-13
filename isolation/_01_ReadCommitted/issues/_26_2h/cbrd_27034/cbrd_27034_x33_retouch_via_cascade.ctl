/*
Test Case: cbrd_27034_x33_retouch_via_cascade
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A cascading DELETE reaches a child row the same transaction updated earlier while another transaction waits for it: no deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27034_c SET v=v+1 WHERE id=1;
C2: UPDATE t27034_c SET v=v+1 WHERE id=1; -- blocks
C1: DELETE FROM t27034_p WHERE id=1;
C1: COMMIT;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27034_c;
C1: DROP TABLE IF EXISTS t27034_p;
C1: CREATE TABLE t27034_p (id INT PRIMARY KEY);
C1: CREATE TABLE t27034_c (id INT PRIMARY KEY, pid INT, v INT, FOREIGN KEY (pid) REFERENCES t27034_p (id) ON DELETE CASCADE);
C1: INSERT INTO t27034_p VALUES (1),(2);
C1: INSERT INTO t27034_c VALUES (1,1,0),(2,2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_c SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_c SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C1: DELETE FROM t27034_p WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_c;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_p;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT SUM(v) FROM t27034_c;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_c;
C1: DROP TABLE t27034_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
