/*
Test Case: repeatable_read_release/rc_sorted_limit_control
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
Control for rr_sorted_limit_frees_cut_rows under READ COMMITTED: the locks of the rows LIMIT cut go back when the
statement ends, another transaction updates such a row, and the first transaction later reads the committed
version again and updates it.

NUM_CLIENTS = 2
C1: UPDATE t28025_t SET v=v+1 WHERE v>=0 ORDER BY v DESC, id DESC LIMIT 1;
C2: set transaction lock timeout 1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=1; -- C2 updates a row LIMIT cut
C2: COMMIT;
C1: UPDATE t28025_t SET v=v+10 WHERE id=1; -- C1 updates the committed version
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
/* C1 updates the committed version */
C1: UPDATE t28025_t SET v=v+10 WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 110, 2 0, 3 1 */
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
