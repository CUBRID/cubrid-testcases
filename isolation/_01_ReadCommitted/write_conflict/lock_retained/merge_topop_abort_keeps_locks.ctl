/*
Test Case: lock_retained/merge_topop_abort_keeps_locks
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
The row locks of a MERGE that fails are kept to commit: an UPDATE of a row it touched waits until the MERGE's transaction rolls back.

NUM_CLIENTS = 2
C1: MERGE INTO t27034_tgt USING t27034_src s ON t27034_tgt.k = s.k WHEN MATCHED THEN UPDATE SET t27034_tgt.v = t27034_tgt.v + 1 WHEN NOT MATCHED THEN INSERT VALUES (s.nid, s.k, s.v); -- fails
C2: UPDATE t27034_tgt SET v = 777 WHERE id = 1; -- blocks
C1: ROLLBACK;
C2: (released)
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
C1: DROP TABLE IF EXISTS t27034_src;
C1: DROP TABLE IF EXISTS t27034_tgt;
C1: CREATE TABLE t27034_tgt (id INT PRIMARY KEY, k INT, v INT);
C1: CREATE TABLE t27034_src (sid INT PRIMARY KEY, k INT, nid INT, v INT);
C1: INSERT INTO t27034_tgt VALUES (1,10,100),(2,20,200);
C1: INSERT INTO t27034_src VALUES (1,10,0,0),(2,99,2,999);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: MERGE INTO t27034_tgt USING t27034_src s ON t27034_tgt.k = s.k WHEN MATCHED THEN UPDATE SET t27034_tgt.v = t27034_tgt.v + 1 WHEN NOT MATCHED THEN INSERT VALUES (s.nid, s.k, s.v);
MC: wait until C1 ready;
C2: UPDATE t27034_tgt SET v = 777 WHERE id = 1;
MC: wait until C2 blocked;
C1: ROLLBACK;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 2 */
C1: SELECT COUNT(*) FROM t27034_tgt;
MC: wait until C1 ready;
/* expect 777 */
C1: SELECT v FROM t27034_tgt WHERE id=1;
MC: wait until C1 ready;
/* expect 200 */
C1: SELECT v FROM t27034_tgt WHERE id=2;
MC: wait until C1 ready;
/* expect 10 */
C1: SELECT k FROM t27034_tgt WHERE id=1;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t27034_tgt;
C1: DROP TABLE t27034_src;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
