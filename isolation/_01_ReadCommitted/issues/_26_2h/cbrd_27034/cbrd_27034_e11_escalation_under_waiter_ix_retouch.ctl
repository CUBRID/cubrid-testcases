/*
Test Case: cbrd_27034_e11_escalation_under_waiter_ix_retouch
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
A bulk UPDATE that touches its own earlier row again and crosses a lowered lock_escalation, while a waiter holds IX on the class, ends without a deadlock and every increment is kept.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1; -- blocks
C1: UPDATE t27034_t SET v=v+1 WHERE id <= 100;
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
C1: DROP TABLE IF EXISTS t27034_t;
C1: CREATE TABLE t27034_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_t SELECT ROWNUM, 0 FROM db_class a, db_class b LIMIT 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C1 ready;
C2: UPDATE t27034_t SET v=v+1 WHERE id=1;
MC: wait until C2 blocked;
C1: UPDATE t27034_t SET v=v+1 WHERE id <= 100;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;

/* expected end state */
/* expect 3 */
C1: SELECT v FROM t27034_t WHERE id=1;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT v FROM t27034_t WHERE id=100;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_t WHERE id=101;
MC: wait until C1 ready;
/* expect 102 */
C1: SELECT SUM(v) FROM t27034_t;
MC: wait until C1 ready;
/* expect 300 */
C1: SELECT COUNT(*) FROM t27034_t;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27034_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
