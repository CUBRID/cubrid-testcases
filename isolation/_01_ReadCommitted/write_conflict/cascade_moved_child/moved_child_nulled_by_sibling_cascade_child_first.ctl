/*
Test Case: cascade_moved_child/moved_child_nulled_by_sibling_cascade_child_first
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The schedule of moved_child_nulled_by_sibling_cascade with e2 ahead of e1 in the DELETE's scan. The result is the same: e2 is kept with its manager nulled.

NUM_CLIENTS = 2
C2: UPDATE t27464_emp SET dept_id=2 WHERE id=2;
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
C1: CREATE TABLE t27464_emp (id INT PRIMARY KEY, dept_id INT, mgr_id INT, FOREIGN KEY (dept_id) REFERENCES t27464_dept(id) ON DELETE CASCADE, FOREIGN KEY (mgr_id) REFERENCES t27464_emp(id) ON DELETE SET NULL);
C1: INSERT INTO t27464_dept VALUES (1),(2);
C1: INSERT INTO t27464_emp VALUES (2,1,NULL);
C1: INSERT INTO t27464_emp VALUES (1,1,NULL);
C1: UPDATE t27464_emp SET mgr_id=1 WHERE id=2;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27464_emp SET dept_id=2 WHERE id=2;
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
C1: SELECT COUNT(*) FROM t27464_dept;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_emp;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_emp WHERE id=2 AND dept_id=2 AND mgr_id IS NULL;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_emp e WHERE e.dept_id IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27464_dept d WHERE d.id=e.dept_id);
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
