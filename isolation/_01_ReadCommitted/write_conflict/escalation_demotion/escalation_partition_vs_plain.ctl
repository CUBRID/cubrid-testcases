/*
Test Case: escalation_demotion/escalation_partition_vs_plain
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
A 200-row UPDATE escalates on a range-partitioned table and on a plain table. In both cases the escalated class lock
is lowered at statement end, so another transaction inserts into the same partition or table without waiting.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
C1: UPDATE t27238_p SET v=v+1 WHERE id <= 200;
C2: INSERT INTO t27238_p VALUES (500, 0);
C1: ROLLBACK;
C2: ROLLBACK;
C1: UPDATE t27238_t SET v=v+1 WHERE id <= 200;
C2: INSERT INTO t27238_t VALUES (500, 0);
C2: ROLLBACK;
C1: ROLLBACK;
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
/* lock_escalation is a server parameter: a case that stopped before its clean up can leave another value */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t27238_t;
C1: DROP TABLE IF EXISTS t27238_p;
C1: CREATE TABLE t27238_p (id INT PRIMARY KEY, v INT) PARTITION BY RANGE (id) (PARTITION p0 VALUES LESS THAN (1000), PARTITION p1 VALUES LESS THAN (2000));
C1: CREATE TABLE t27238_t (id INT PRIMARY KEY, v INT);
C1: INSERT INTO t27238_p SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: INSERT INTO t27238_t SELECT ROWNUM, ROWNUM FROM db_class a, db_class b LIMIT 300;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=20';
MC: wait until C1 ready;
C1: UPDATE t27238_p SET v=v+1 WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27238_p VALUES (500, 0);
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;
C2: ROLLBACK;
MC: wait until C2 ready;
C1: UPDATE t27238_t SET v=v+1 WHERE id <= 200;
MC: wait until C1 ready;
C2: INSERT INTO t27238_t VALUES (500, 0);
MC: wait until C2 ready;
C2: ROLLBACK;
MC: wait until C2 ready;
C1: ROLLBACK;
MC: wait until C1 ready;

/* expected end state */
/* expect 300 */
C1: SELECT COUNT(*) FROM t27238_p;
MC: wait until C1 ready;
/* expect 300 */
C1: SELECT COUNT(*) FROM t27238_t;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27238_p WHERE id=500;
MC: wait until C1 ready;
/* expect 0 */
C1: SELECT COUNT(*) FROM t27238_t WHERE id=500;
MC: wait until C1 ready;
/* expect 200 */
C1: SELECT COUNT(*) FROM t27238_p WHERE id<=200 AND v=id;
MC: wait until C1 ready;
/* expect 200 */
C1: SELECT COUNT(*) FROM t27238_t WHERE id<=200 AND v=id;
MC: wait until C1 ready;
/* expect 20100 */
C1: SELECT SUM(v) FROM t27238_p WHERE id<=200;
MC: wait until C1 ready;
/* expect 20100 */
C1: SELECT SUM(v) FROM t27238_t WHERE id<=200;
MC: wait until C1 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_p;
C1: DROP TABLE t27238_t;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
