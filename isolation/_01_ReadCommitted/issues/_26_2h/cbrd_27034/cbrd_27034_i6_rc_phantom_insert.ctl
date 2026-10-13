/*
Test Case: cbrd_27034_i6_rc_phantom_insert
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Under READ COMMITTED a count taken again after another transaction inserted and committed a row includes the new row.

NUM_CLIENTS = 3
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
C2: SELECT COUNT(*) FROM t27034_t;
C1: INSERT INTO t27034_t VALUES (4,40);
C1: COMMIT;
C2: SELECT COUNT(*) FROM t27034_t;
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
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT);
C1: INSERT INTO t27034_t VALUES (1,10),(2,20),(3,30);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
MC: wait until C2 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
C1: INSERT INTO t27034_t VALUES (4,40);
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;

/* expected end state */
/* expect 4 */
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_t WHERE id=4;
MC: wait until C2 ready;
/* expect 4 */
C3: SELECT COUNT(*) FROM t27034_t;
MC: wait until C3 ready;
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
