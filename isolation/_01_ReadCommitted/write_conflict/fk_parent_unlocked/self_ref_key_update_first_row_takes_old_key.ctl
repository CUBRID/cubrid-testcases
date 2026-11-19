/*
Test Case: fk_parent_unlocked/self_ref_key_update_first_row_takes_old_key
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A self-referencing table (ON UPDATE SET NULL) holds the rows (2, NULL) and (1, 1), inserted in this order so that the UPDATE meets row 2 first. One UPDATE gives row 2 the key 1 and row 1 the key 101. Row 1 refers to its own key 1, which the UPDATE changes, so the UPDATE fails with the foreign key error and both rows stay. The foreign key index and a heap scan then return the same row that refers to key 1.
A build that skips the check of the self-referencing foreign key commits the UPDATE: row 101 then refers to the row that took key 1, and the foreign key index has no entry for it.
The case was in sql/_36_guava/cbrd_27463. The SQL suites run with ha_mode=yes, which fails this UPDATE on the duplicate key 1 before the foreign key check, so the case runs here.

NUM_CLIENTS = 1
C1: UPDATE t27463_emp SET id = CASE id WHEN 2 THEN 1 ELSE 101 END;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_emp;
C1: CREATE TABLE t27463_emp (id INT PRIMARY KEY, mgr INT, v INT, CONSTRAINT fk_t27463_emp_mgr FOREIGN KEY (mgr) REFERENCES t27463_emp(id) ON UPDATE SET NULL);
C1: INSERT INTO t27463_emp VALUES (2,NULL,20);
C1: INSERT INTO t27463_emp VALUES (1,1,10);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27463_emp SET id = CASE id WHEN 2 THEN 1 ELSE 101 END;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect (1,1,10),(2,NULL,20) */
C1: SELECT id, mgr, v FROM t27463_emp ORDER BY id;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_emp c WHERE c.mgr IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_emp p WHERE p.id=c.mgr);
MC: wait until C1 ready;
/* expect 1, through the foreign key index */
C1: SELECT /*+ recompile */ id FROM t27463_emp WHERE mgr = 1 USING INDEX fk_t27463_emp_mgr(+) ORDER BY id;
MC: wait until C1 ready;
/* expect 1, through a heap scan */
C1: SELECT /*+ recompile */ id FROM t27463_emp WHERE mgr = 1 USING INDEX NONE ORDER BY id;
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27463_emp;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
