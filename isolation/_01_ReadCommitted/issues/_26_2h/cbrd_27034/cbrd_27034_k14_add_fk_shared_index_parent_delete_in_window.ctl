/*
Test Case: cbrd_27034_k14_add_fk_shared_index_parent_delete_in_window
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
ALTER ... ADD FOREIGN KEY on an existing index waits for SIX on the parent class while another transaction holds IX; that transaction's parent DELETE commits, and the ALTER then fails on the missing parent.

NUM_CLIENTS = 2
C2: UPDATE t27034_parent SET note = 'x' WHERE id = 2;
C1: ALTER TABLE t27034_child ADD CONSTRAINT fk_child_pid FOREIGN KEY (pid) REFERENCES t27034_parent (id); -- blocks
C2: DELETE FROM t27034_parent WHERE id = 1;
C2: COMMIT;
C1: (released, fails)
C1: ROLLBACK;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27034_child;
C1: DROP TABLE IF EXISTS t27034_parent;
C1: CREATE TABLE t27034_parent (id INT PRIMARY KEY, note VARCHAR(20));
C1: CREATE TABLE t27034_child (cid INT PRIMARY KEY, pid INT);
C1: CREATE INDEX i_child_pid ON t27034_child (pid);
C1: INSERT INTO t27034_parent VALUES (1,'a'),(2,'b');
C1: INSERT INTO t27034_child VALUES (10,1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27034_parent SET note = 'x' WHERE id = 2;
MC: wait until C2 ready;
C1: ALTER TABLE t27034_child ADD CONSTRAINT fk_child_pid FOREIGN KEY (pid) REFERENCES t27034_parent (id);
MC: wait until C1 blocked;
C2: DELETE FROM t27034_parent WHERE id = 1;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 0 */
C1: SELECT (SELECT COUNT(*) FROM t27034_child c WHERE NOT EXISTS (SELECT 1 FROM t27034_parent p WHERE p.id = c.pid)) * (SELECT COUNT(*) FROM db_index i WHERE i.class_name = 't27034_child' AND i.is_foreign_key = 'YES') FROM db_root;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM db_index i WHERE i.class_name = 't27034_child' AND i.is_foreign_key = 'YES';
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27034_parent WHERE id = 1;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_child;
C1: DROP TABLE t27034_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
