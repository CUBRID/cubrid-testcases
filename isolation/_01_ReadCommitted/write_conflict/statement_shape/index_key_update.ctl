/*
Test Case: statement_shape/index_key_update
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A non-key UPDATE and an index-key UPDATE committed one after the other leave the index and the heap consistent.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET v=1 WHERE id=2;
C1: COMMIT;
C1: UPDATE t27034_t SET k=999 WHERE id=2;
C1: COMMIT;
C2: SELECT id, k, v FROM t27034_t ORDER BY id;
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
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT, v INT);
C1: CREATE INDEX i_t_k ON t27034_t (k);
C1: INSERT INTO t27034_t VALUES (1,100,0),(2,200,0),(3,300,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=1 WHERE id=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C1: UPDATE t27034_t SET k=999 WHERE id=2;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: SELECT id, k, v FROM t27034_t ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 3 */
C2: SELECT COUNT(*) FROM t27034_t;
MC: wait until C2 ready;
/* expect 999 */
C2: SELECT k FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 100 */
C2: SELECT k FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
/* expect 300 */
C2: SELECT k FROM t27034_t WHERE id=3;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_t WHERE k=999;
MC: wait until C2 ready;
/* expect 0 */
C2: SELECT COUNT(*) FROM t27034_t WHERE k=200;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT SUM(v) FROM t27034_t;
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
