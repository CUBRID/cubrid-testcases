/*
Test Case: owner_retouch/retouch_via_view_dont_reuse_oid
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
On a DONT_REUSE_OID table, the transaction that updated a row updates it again through a view while another transaction waits to update it.
An update through a view runs on the client, whose lock request has no owner check, and only a DONT_REUSE_OID table can be updated through a view.
So such a table keeps its DELETE and UPDATE row locks to commit: the second transaction waits for the row X, the owner's update through the view finds its own X, and all three updates apply.
If the first UPDATE gave its row lock back, the waiter would take the X and wait on the owner's stamp, and the owner would queue behind that X: a deadlock.

NUM_CLIENTS = 2
C1: UPDATE t27034_w SET v=v+1 WHERE id=1;
C2: UPDATE t27034_w SET v=v+10 WHERE id=1; -- blocks
C1: UPDATE t27034_wv SET v=v+100 WHERE id=1;
C1: COMMIT;
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
C1: DROP VIEW IF EXISTS t27034_wv;
C1: DROP TABLE IF EXISTS t27034_w;
C1: CREATE TABLE t27034_w (id INT PRIMARY KEY, v INT) DONT_REUSE_OID;
C1: INSERT INTO t27034_w VALUES (1,0),(2,0);
C1: CREATE VIEW t27034_wv AS SELECT id, v FROM t27034_w;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_w SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_w SET v=v+10 WHERE id=1;
MC: wait until C2 blocked;
/* the owner updates the row again through the view, which runs on the client */
C1: UPDATE t27034_wv SET v=v+100 WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 111 */
C2: SELECT v FROM t27034_w WHERE id=1;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP VIEW t27034_wv;
C1: DROP TABLE t27034_w;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
