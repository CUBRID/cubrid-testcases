/*
Test Case: cbrd_27034_x5_repeatable_read
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
Under REPEATABLE READ an UPDATE of a row another transaction committed after the snapshot fails, while an UPDATE of an untouched row succeeds.

NUM_CLIENTS = 3
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
C2: SELECT v FROM t27034_t WHERE id=1;
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C1: COMMIT;
C2: UPDATE t27034_t SET v=v+100 WHERE id=1; -- fails
C2: SELECT v FROM t27034_t WHERE id=1;
C2: UPDATE t27034_t SET v=v+5 WHERE id=2;
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
C2: SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
MC: wait until C2 ready;
C2: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+100 WHERE id=1;
MC: wait until C2 ready;
C2: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
C2: UPDATE t27034_t SET v=v+5 WHERE id=2;
MC: wait until C2 ready;

/* expected end state */
/* expect 0 */
C2: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C2 ready;
/* expect 5 */
C2: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C2 ready;
/* expect 1 */
C3: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C3 ready;
/* expect 0 */
C3: SELECT v FROM t27034_t WHERE id=2;
MC: wait until C3 ready;
/* expect 2 */
C3: SELECT COUNT(*) FROM t27034_t;
MC: wait until C3 ready;

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
