/*
Test Case: writer_conflict/index_key_update_contended
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
An UPDATE that looks a row up by an index key another transaction is changing waits, and updates nothing once the key change commits.

NUM_CLIENTS = 2
C1: UPDATE t27034_t SET k=999 WHERE id=2;
C2: UPDATE t27034_t SET v=v+1 WHERE k=200; -- blocks
C1: COMMIT;
C2: (released)
C2: SELECT id, k, v FROM t27034_t ORDER BY id;
C2: COMMIT;
C1: SELECT id, k, v FROM t27034_t ORDER BY id;
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
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, k INT, v INT);
C1: CREATE INDEX i_t_k ON t27034_t (k);
C1: INSERT INTO t27034_t VALUES (1,100,0),(2,200,0),(3,300,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET k=999 WHERE id=2;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE k=200;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, k, v FROM t27034_t ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: SELECT id, k, v FROM t27034_t ORDER BY id;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 999 */
C1: SELECT k FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=3;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT SUM(v) FROM t27034_t;
MC: wait until C1 ready;
/* expect 3 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_t WHERE k=200;
MC: wait until C1 ready;
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
