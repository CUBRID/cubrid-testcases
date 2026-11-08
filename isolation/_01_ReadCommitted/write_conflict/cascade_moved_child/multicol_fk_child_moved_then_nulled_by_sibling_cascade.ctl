/*
Test Case: cascade_moved_child/multicol_fk_child_moved_then_nulled_by_sibling_cascade
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
A two-column foreign key (a, b). C2 moves c2 from (5, 1) to (5, 2) and commits while the DELETE of (5, 1) waits for c2. The cascade of c1 nulls c2.a through a self reference, so c2's key becomes (NULL, 2). c2 is kept.

NUM_CLIENTS = 2
C2: UPDATE t27464_c SET b=2 WHERE id=6;
C1: DELETE FROM t27464_p WHERE x=5 AND y=1;
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
C1: DROP TABLE IF EXISTS t27464_c;
C1: DROP TABLE IF EXISTS t27464_p;
C1: CREATE TABLE t27464_p (x INT, y INT, PRIMARY KEY (x, y));
C1: CREATE TABLE t27464_c (id INT PRIMARY KEY, a INT, b INT, FOREIGN KEY (a, b) REFERENCES t27464_p(x, y) ON DELETE CASCADE);
C1: ALTER TABLE t27464_c ADD CONSTRAINT fk_t27464_c_self FOREIGN KEY (a) REFERENCES t27464_c(id) ON DELETE SET NULL;
C1: INSERT INTO t27464_p VALUES (5,1),(5,2);
C1: INSERT INTO t27464_c VALUES (5,5,1);
C1: INSERT INTO t27464_c VALUES (6,5,1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27464_c SET b=2 WHERE id=6;
MC: wait until C2 ready;
C1: DELETE FROM t27464_p WHERE x=5 AND y=1;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_p;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_c;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_c WHERE id=6 AND a IS NULL AND b=2;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_c;
C1: DROP TABLE t27464_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
