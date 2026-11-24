/*
Test Case: repeatable_read_release/rr_join_update_unmatched_row
Priority: 1
Reference case: CBRD-28025 (CUBRID/cubrid#8652)
Author: hgryoo

Test Point:
Under REPEATABLE READ a join UPDATE whose other table has no index changes only the target rows with a partner.
Another transaction updates a target row with no partner and commits while the first transaction is open.

NUM_CLIENTS = 2
C1: UPDATE t28025_t t, t28025_u u SET t.v=t.v+1 WHERE t.id=u.id; -- with the ORDERED hint, the target table is the outer one
C2: set transaction lock timeout 1;
C2: UPDATE t28025_t SET v=v+100 WHERE id=1; -- C2 updates a row with no partner
C2: COMMIT;
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
C1: DROP TABLE IF EXISTS t28025_u;
C1: CREATE TABLE t28025_u (id INT);
C1: INSERT INTO t28025_u VALUES (3);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: UPDATE /*+ ORDERED */ t28025_t t, t28025_u u SET t.v=t.v+1 WHERE t.id=u.id;
MC: wait until C1 ready;
C2: set transaction lock timeout 1;
MC: wait until C2 ready;
/* C2 updates a row with no partner */
C2: UPDATE t28025_t SET v=v+100 WHERE id=1;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
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
C1: DROP TABLE t28025_u;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
