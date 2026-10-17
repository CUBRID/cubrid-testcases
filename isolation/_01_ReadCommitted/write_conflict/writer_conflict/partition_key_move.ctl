/*
Test Case: writer_conflict/partition_key_move
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
An UPDATE that moves a row to another partition and a concurrent UPDATE of the same row by its old key: the waiter updates nothing once the move commits.

NUM_CLIENTS = 2
C1: UPDATE t27034_p SET id=15 WHERE id=1;
C2: UPDATE t27034_p SET v=v+1 WHERE id=1; -- blocks
C1: COMMIT;
C2: (released)
C2: SELECT id, v FROM t27034_p ORDER BY id;
C2: COMMIT;
C1: SELECT id, v FROM t27034_p ORDER BY id;
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
C1: DROP TABLE IF EXISTS t27034_p;
C1: CREATE TABLE t27034_p (id INT PRIMARY KEY, v INT) PARTITION BY RANGE (id) (PARTITION p0 VALUES LESS THAN (10), PARTITION p1 VALUES LESS THAN (20));
C1: INSERT INTO t27034_p VALUES (1,100),(2,200),(11,300);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_p SET id=15 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_p SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, v FROM t27034_p ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: SELECT id, v FROM t27034_p ORDER BY id;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 3 */
C1: SELECT COUNT(*) FROM t27034_p;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_p WHERE id=1;
MC: wait until C1 ready;
/* expect 100 */
C1: SELECT v FROM t27034_p WHERE id=15;
MC: wait until C1 ready;
/* expect 200 */
C1: SELECT v FROM t27034_p WHERE id=2;
MC: wait until C1 ready;
/* expect 300 */
C1: SELECT v FROM t27034_p WHERE id=11;
MC: wait until C1 ready;
/* expect 600 */
C1: SELECT SUM(v) FROM t27034_p;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
