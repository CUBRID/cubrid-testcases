/*
Test Case: owner_retouch/retouch_behind_writer_queued_past_fk_holder
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881), CBRD-27463 (CUBRID/cubrid#8198)
Author: hgryoo

Test Point:
A transaction has an uncommitted child of a parent row, and another transaction's UPDATE of the parent waits on the stamp of the transaction that updated it in an earlier statement.
That owner updates the parent again. It gets the row at once, ahead of the waiting writer, and the writer goes on waiting on the owner's stamp.
Queued behind the writer instead, the owner would wait for the writer while the writer waits on the owner: a deadlock.
CBRD-27034 wrote this case when the foreign key check of a child insert held S on the parent row, so the writer and then the owner queued behind that S, and the owner had to get the row first when the S went.
Since CBRD-27463 the check takes no lock on a committed parent row, so there is no S to wait for.
The name keeps "fk_holder". This case no longer reaches the path where the owner waits for S holders on the row, and no other case covers that path.

NUM_CLIENTS = 3
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
C2: INSERT INTO t27034_c VALUES (10,1);
C3: UPDATE t27034_p SET v=v+100 WHERE id=1; -- blocks: waits on C1's stamp
C1: UPDATE t27034_p SET v=v+1 WHERE id=1; -- does not block
C2: COMMIT;
C1: COMMIT;
C3: (released)
C3: COMMIT;
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
C1: DROP TABLE IF EXISTS t27034_c;
C1: DROP TABLE IF EXISTS t27034_p;
C1: CREATE TABLE t27034_p (id INT PRIMARY KEY, v INT);
C1: CREATE TABLE t27034_c (cid INT PRIMARY KEY, pid INT, FOREIGN KEY (pid) REFERENCES t27034_p (id));
C1: INSERT INTO t27034_p VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: INSERT INTO t27034_c VALUES (10,1);
MC: wait until C2 ready;
C3: UPDATE t27034_p SET v=v+100 WHERE id=1;
MC: wait until C3 blocked;
/* the owner touches the row again, ahead of C3 */
C1: UPDATE t27034_p SET v=v+1 WHERE id=1;
/* CBRD-27463: C2's child INSERT leaves no lock on the parent row, so the owner touches it again at once; C3 still waits on C1's stamp */
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;

/* expected end state */
/* expect 102 */
C2: SELECT v FROM t27034_p WHERE id=1;
MC: wait until C2 ready;
/* expect 1 */
C2: SELECT COUNT(*) FROM t27034_c;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27034_c;
C1: DROP TABLE t27034_p;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
