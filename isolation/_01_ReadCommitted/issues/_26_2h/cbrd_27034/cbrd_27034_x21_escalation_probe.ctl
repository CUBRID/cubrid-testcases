/*
Test Case: cbrd_27034_x21_escalation_probe
Priority: 1
Reference case: CBRD-27034 (CUBRID/cubrid#7881)
Author: hgryoo

Test Point:
An UPDATE on a partitioned table that crosses a lowered lock_escalation and rolls back, while another transaction inserts into another partition: both outcomes are as committed.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27034_p SET v=v+1 WHERE id <= 200;
C2: INSERT INTO t27034_p VALUES (1500, 0);
C2: COMMIT;
C1: ROLLBACK;
C1: SELECT COUNT(*) FROM t27034_p;
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
C1: DROP TABLE IF EXISTS t27034_q;
C1: DROP TABLE IF EXISTS t27034_p;
C1: CREATE TABLE t27034_p (id INT PRIMARY KEY, v INT) PARTITION BY RANGE (id) (PARTITION p0 VALUES LESS THAN (1000), PARTITION p1 VALUES LESS THAN (2000));
C1: CREATE TABLE t27034_q (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27034_p SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: INSERT INTO t27034_q VALUES (1,1);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27034_p SET v=v+1 WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27034_p VALUES (1500, 0);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C1: SELECT COUNT(*) FROM t27034_p;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 301 */
C1: SELECT COUNT(*) FROM t27034_p;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_p WHERE id=1500;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT v FROM t27034_p WHERE id=1500;
MC: wait until C1 ready;
/* expect 200 */
C1: SELECT COUNT(*) FROM t27034_p WHERE id<=200 AND v=id;
MC: wait until C1 ready;
/* expect 20100 */
C1: SELECT SUM(v) FROM t27034_p WHERE id<=200;
MC: wait until C1 ready;
/* expect 1 */
C1: SELECT COUNT(*) FROM t27034_q;
MC: wait until C1 ready;
/* the scenario also checks that cubrid checkdb reports no error; an isolation case cannot */

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27034_p;
C1: DROP TABLE t27034_q;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
