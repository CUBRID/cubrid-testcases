/*
Test Case: cascade_moved_child/two_fks_setnull_first_child_moved_then_parent_delete
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The child class references the parent through two foreign keys: a ON DELETE SET NULL, declared first, and b ON DELETE CASCADE. C2 moves e2's b to another parent and commits while the DELETE waits for e2. The SET NULL of a writes e2 before b is processed; e2 is kept as (2, NULL, 2).

NUM_CLIENTS = 2
C2: UPDATE t27464_emp SET b=2 WHERE id=2;
C1: DELETE FROM t27464_dept WHERE id=1;
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
C1: DROP TABLE IF EXISTS t27464_emp;
C1: DROP TABLE IF EXISTS t27464_dept;
C1: CREATE TABLE t27464_dept (id INT PRIMARY KEY);
C1: CREATE TABLE t27464_emp (id INT PRIMARY KEY, a INT, b INT, FOREIGN KEY (a) REFERENCES t27464_dept(id) ON DELETE SET NULL, FOREIGN KEY (b) REFERENCES t27464_dept(id) ON DELETE CASCADE);
C1: INSERT INTO t27464_dept VALUES (1),(2);
C1: INSERT INTO t27464_emp VALUES (2,1,1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27464_emp SET b=2 WHERE id=2;
MC: wait until C2 ready;
C1: DELETE FROM t27464_dept WHERE id=1;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_emp;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_emp WHERE id=2 AND a IS NULL AND b=2;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_emp;
C1: DROP TABLE t27464_dept;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
