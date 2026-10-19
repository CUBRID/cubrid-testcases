/*
Test Case: cascade_desc_pk/dedup_desc_char_pk_cascade_and_setnull
Priority: 1
Reference case: CBRD-27464 (CUBRID/cubrid#8026)
Author: hgryoo

Test Point:
Two deduplicated foreign keys whose CHAR(8) column refers to a CHAR(4) DESC primary key column, one CASCADE and one SET NULL: the CASCADE children are deleted and the SET NULL child is nulled.

NUM_CLIENTS = 1
C1: DELETE FROM t27464_father WHERE a='1' AND b=1;
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 1;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t27464_child2;
C1: DROP TABLE IF EXISTS t27464_child;
C1: DROP TABLE IF EXISTS t27464_father;
C1: SET SYSTEM PARAMETERS 'deduplicate_key_level=10';
C1: CREATE TABLE t27464_father (a CHAR(4), b INT, note VARCHAR(20), PRIMARY KEY (a DESC, b));
C1: CREATE TABLE t27464_child (id INT PRIMARY KEY, fa CHAR(8), fb INT, FOREIGN KEY (fa, fb) REFERENCES t27464_father(a, b) ON DELETE CASCADE);
C1: CREATE TABLE t27464_child2 (id INT PRIMARY KEY, fa CHAR(8), fb INT, FOREIGN KEY (fa, fb) REFERENCES t27464_father(a, b) ON DELETE SET NULL);
C1: INSERT INTO t27464_father VALUES ('1',1,'p'),('2',2,'q'),('3',3,'r');
C1: INSERT INTO t27464_child VALUES (10,'1',1),(11,'1',1),(20,'2',2);
C1: INSERT INTO t27464_child2 VALUES (30,'1',1),(40,'2',2);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t27464_father WHERE a='1' AND b=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM _db_index_key WHERE key_attr_name='_dedup_10';
MC: wait until C1 ready;
/* expect 2 */
C1: SELECT COUNT(*) FROM t27464_father;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27464_child WHERE id IN (10, 11);
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child2 WHERE id=30 AND fa IS NULL AND fb IS NULL;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27464_child2 WHERE id=40 AND fb=2;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C1: DROP TABLE t27464_child2;
C1: DROP TABLE t27464_child;
C1: DROP TABLE t27464_father;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
