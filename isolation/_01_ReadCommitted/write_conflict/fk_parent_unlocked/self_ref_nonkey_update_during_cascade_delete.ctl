/*
Test Case: fk_parent_unlocked/self_ref_nonkey_update_during_cascade_delete
Priority: 1
Reference case: CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A self-referencing table (ON DELETE CASCADE, ON UPDATE SET NULL). C3 updates a non-key column of child 3 of row 7 and keeps its transaction open. The DELETE of row 7 by C1 marks key 7 deleted and waits for C3. C2 then updates a non-key column of child 2 of row 7.
An UPDATE that does not set the referencing column does not check that foreign key again, also on a self-referencing table, so the UPDATE of C2 does not wait for the mark of C1 and the two do not deadlock. Only an UPDATE that can change the referenced key checks a self-referencing foreign key again. After C3 rolls back and C2 commits, the DELETE removes rows 7, 3 and 2.

NUM_CLIENTS = 3
C3: UPDATE t27463_emp SET v = v + 1 WHERE id = 3;
C1: DELETE FROM t27463_emp WHERE id = 7;
C2: UPDATE t27463_emp SET v = v + 1 WHERE id = 2;
C2: COMMIT;
C3: ROLLBACK;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 3;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
/* a build that checks the self-referencing foreign key again makes C2 wait for the mark of C1 while C1 waits for C3; the finite timeout ends that wait with an error instead of a hang */
C2: set transaction lock timeout 10;
C2: set transaction isolation level read committed;
C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27463_emp;
C1: CREATE TABLE t27463_emp (id INT PRIMARY KEY, mgr INT, v INT, FOREIGN KEY (mgr) REFERENCES t27463_emp(id) ON DELETE CASCADE ON UPDATE SET NULL);
C1: INSERT INTO t27463_emp VALUES (7,NULL,0);
C1: INSERT INTO t27463_emp VALUES (3,7,0),(2,7,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C3: UPDATE t27463_emp SET v = v + 1 WHERE id = 3;
MC: wait until C3 ready;
C1: DELETE FROM t27463_emp WHERE id = 7;
MC: wait until C1 blocked;
C2: UPDATE t27463_emp SET v = v + 1 WHERE id = 2;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C3: ROLLBACK;
MC: wait until C3 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_emp;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27463_emp c WHERE c.mgr IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27463_emp p WHERE p.id=c.mgr);
MC: wait until C1 ready;
/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27463_emp;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
