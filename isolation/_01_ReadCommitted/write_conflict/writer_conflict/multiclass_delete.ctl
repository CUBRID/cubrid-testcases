/*
Test Case: writer_conflict/multiclass_delete
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A DELETE over two tables waits for an update of one of them and then deletes only the rows that still match.

NUM_CLIENTS = 2
C1: UPDATE t27034_a SET k=99 WHERE id=2;
C2: DELETE t27034_a, t27034_b FROM t27034_a, t27034_b WHERE t27034_a.k = t27034_b.k; -- blocks
C1: COMMIT;
C2: (released)
C2: SELECT id, k FROM t27034_a ORDER BY id;
C2: SELECT id, k FROM t27034_b ORDER BY id;
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
C1: DROP TABLE IF EXISTS t27034_b;
C1: DROP TABLE IF EXISTS t27034_a;
C1: CREATE TABLE t27034_a (id INT PRIMARY KEY, k INT);
C1: CREATE TABLE t27034_b (id INT PRIMARY KEY, k INT);
C1: INSERT INTO t27034_a VALUES (1,10),(2,20),(3,30);
C1: INSERT INTO t27034_b VALUES (1,10),(2,20),(3,30);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_a SET k=99 WHERE id=2;
MC: wait until C1 ready;
C2: DELETE t27034_a, t27034_b FROM t27034_a, t27034_b WHERE t27034_a.k = t27034_b.k;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: SELECT id, k FROM t27034_a ORDER BY id;
MC: wait until C2 ready;
C2: SELECT id, k FROM t27034_b ORDER BY id;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_a;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_b;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_a;
C1: DROP TABLE t27034_b;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
