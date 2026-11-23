/*
Test Case: repeatable_read_release/rr_sorted_limit_frees_cut_rows
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
Under REPEATABLE READ an UPDATE ... ORDER BY v DESC, id DESC LIMIT 1 sorts before LIMIT and locks the rows it
reads, but changes one.  The locks of the rows LIMIT cut go back when the statement ends: another transaction
updates such a row and commits, and the first transaction gets the serialization error when it later updates that
row.  Before CBRD-28025 the other transaction times out on the row lock and the first one updates the row.

NUM_CLIENTS = 2
C1: UPDATE t28025_t SET v=v+1 WHERE v>=0 ORDER BY v DESC, id DESC LIMIT 1;
C2: set transaction lock timeout 1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=1; -- C2 updates a row LIMIT cut
C2: COMMIT;
C1: UPDATE t28025_t SET v=v+10 WHERE id=1; -- C1 gets the serialization error
C1: COMMIT;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t28025_t;
C1: CREATE TABLE t28025_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t28025_t VALUES (1,0),(2,0),(3,0);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE t28025_t SET v=v+1 WHERE v>=0 ORDER BY v DESC, id DESC LIMIT 1;
MC: wait until C1 ready;
C2: set transaction lock timeout 1;
MC: wait until C2 ready;
/* C2 updates a row LIMIT cut */
C2: UPDATE t28025_t SET v=v+100 WHERE id=1;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
/* C1 gets the serialization error */
C1: UPDATE t28025_t SET v=v+10 WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 100, 2 0, 3 1 */
C1: SELECT id, v FROM t28025_t ORDER BY id;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: DROP TABLE t28025_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
