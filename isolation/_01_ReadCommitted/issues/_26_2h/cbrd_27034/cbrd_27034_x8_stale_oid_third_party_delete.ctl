/*
Test Case: cbrd_27034_x8_stale_oid_third_party_delete
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A multi-row UPDATE waiting on one row skips a later row that a third transaction deletes and commits meanwhile.

NUM_CLIENTS = 3
C1: UPDATE t27034_t SET tag='A' WHERE id=2;
C2: UPDATE t27034_t SET v=v+1 WHERE tag='A'; -- blocks
C3: DELETE FROM t27034_t WHERE id=5;
C3: COMMIT;
C3: INSERT INTO t27034_t VALUES (6,0,'A');
C3: COMMIT;
C1: COMMIT;
C2: (released)
C2: SELECT id, v, tag FROM t27034_t ORDER BY id;
C2: COMMIT;
C1: SELECT id, v, tag FROM t27034_t ORDER BY id;
C1: COMMIT;
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
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT, tag VARCHAR(10));
C1: INSERT INTO t27034_t VALUES (1,0,'A'),(2,0,'A'),(3,0,'A'),(4,0,'A'),(5,0,'A');
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET tag='A' WHERE id=2;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE tag='A';
MC: wait until C2 blocked;
C3: DELETE FROM t27034_t WHERE id=5;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C3: INSERT INTO t27034_t VALUES (6,0,'A');
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, v, tag FROM t27034_t ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: SELECT id, v, tag FROM t27034_t ORDER BY id;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 5 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=3;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=4;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_t WHERE id=5;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=6;
MC: wait until C1 ready;
/* expect 4 */
C1: SELECT SUM(v) FROM t27034_t;
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
