/*
Test Case: cascade_moved_child/multicol_fk_child_moved_after_enumeration_nulled_by_sibling_cascade
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The two-column key of multicol_fk_child_moved_then_nulled_by_sibling_cascade, with c2 moved while the DELETE waits for c0, which C3 locked FOR UPDATE. c2 is kept as (6, NULL, 2).

NUM_CLIENTS = 3
C3: SELECT * FROM t27464_c WHERE id=4 FOR UPDATE;
C1: DELETE FROM t27464_p WHERE x=5 AND y=1;
C2: UPDATE t27464_c SET b=2 WHERE id=6;
C2: COMMIT;
C3: COMMIT;
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
C1: DROP TABLE IF EXISTS t27464_c;
C1: DROP TABLE IF EXISTS t27464_p;
C1: CREATE TABLE t27464_p (x INT, y INT, PRIMARY KEY (x, y));
C1: CREATE TABLE t27464_c (id INT PRIMARY KEY, a INT, b INT, FOREIGN KEY (a, b) REFERENCES t27464_p(x, y) ON DELETE CASCADE);
C1: INSERT INTO t27464_p VALUES (4,1),(5,1),(5,2);
C1: INSERT INTO t27464_c VALUES (4,5,1);
C1: INSERT INTO t27464_c VALUES (5,5,1);
C1: INSERT INTO t27464_c VALUES (6,5,1);
C1: ALTER TABLE t27464_c ADD CONSTRAINT fk_t27464_c_self FOREIGN KEY (a) REFERENCES t27464_c(id) ON DELETE SET NULL;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: SELECT * FROM t27464_c WHERE id=4 FOR UPDATE;
MC: wait until C3 ready;
C1: DELETE FROM t27464_p WHERE x=5 AND y=1;
MC: wait until C1 blocked;
C2: UPDATE t27464_c SET b=2 WHERE id=6;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: COMMIT;
MC: wait until C3 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
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
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27464_c;
C1: DROP TABLE t27464_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
