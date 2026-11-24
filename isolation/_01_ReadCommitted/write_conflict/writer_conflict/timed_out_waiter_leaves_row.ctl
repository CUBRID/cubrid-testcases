/*
Test Case: writer_conflict/timed_out_waiter_leaves_row
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A transaction that waits for the row's last writer and times out keeps no lock on the row, though it stays open.
A third transaction that queued on the same row goes on as soon as the first writer commits.
If the timed-out transaction kept the row lock it took for the wait, the third would wait for it and time out.

NUM_CLIENTS = 3
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+10 WHERE id=1; -- waits for C1 and times out after 2 seconds
C3: UPDATE t27034_t SET v=v+100 WHERE id=1; -- blocks
C1: COMMIT;
C3: (released, while C2 is still open)
C3: COMMIT;
C2: COMMIT;
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t VALUES (1,0),(2,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: set transaction lock timeout 2;
MC: wait until C2 ready;
/* C2 waits for C1 and times out; C2 stays open */
C2: UPDATE t27034_t SET v=v+10 WHERE id=1;
MC: wait until C2 ready;
/* a lock left by C2 would make C3 time out instead of waiting forever */
C3: set transaction lock timeout 10;
MC: wait until C3 ready;
C3: UPDATE t27034_t SET v=v+100 WHERE id=1;
MC: wait until C3 blocked;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 101 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C3: rollback work;
MC: wait until C3 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
