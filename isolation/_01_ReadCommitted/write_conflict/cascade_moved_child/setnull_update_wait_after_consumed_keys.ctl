/*
Test Case: cascade_moved_child/setnull_update_wait_after_consumed_keys
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
The same as cascade_wait_after_consumed_keys for a parent key UPDATE under ON UPDATE SET NULL: every child still referring to the old key is nulled and the moved one keeps its new parent.

NUM_CLIENTS = 2
C2: UPDATE t27464_child SET pid=2 WHERE cid=64;
C1: UPDATE t27464_parent SET id=3 WHERE id=1;
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
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_parent;
C1: SET SYSTEM PARAMETERS 'deduplicate_key_level=0';
C1: CREATE TABLE t27464_parent (id INT PRIMARY KEY);
C1: CREATE TABLE t27464_child (cid INT PRIMARY KEY, pid INT, p1 CHAR(250), p2 CHAR(250), p3 CHAR(250), p4 CHAR(250), FOREIGN KEY (pid) WITH DEDUPLICATE=14 REFERENCES t27464_parent(id) ON UPDATE SET NULL);
C1: INSERT INTO t27464_parent VALUES (1),(2);
C1: INSERT INTO t27464_child SELECT ROWNUM, 1, 'a', 'b', 'c', 'd' FROM db_class a, db_class b LIMIT 64;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C2: UPDATE t27464_child SET pid=2 WHERE cid=64;
MC: wait until C2 ready;
C1: UPDATE t27464_parent SET id=3 WHERE id=1;
MC: wait until C1 blocked;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C1: SELECT COUNT(*) FROM _db_index_key WHERE key_attr_name='_dedup_14';
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE pid=1;
MC: wait until C1 ready;
/* expect 63 */
C1: SELECT COUNT(*) FROM t27464_child WHERE pid IS NULL;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child WHERE pid=2;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child c WHERE c.pid IS NOT NULL AND NOT EXISTS (SELECT 1 FROM t27464_parent p WHERE p.id=c.pid);
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_parent;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
