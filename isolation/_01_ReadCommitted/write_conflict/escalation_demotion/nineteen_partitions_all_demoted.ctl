/*
Test Case: escalation_demotion/nineteen_partitions_all_demoted
Priority: 1
Reference case: CBRD-27238 (CUBRID/cubrid#8277)
Author: hgryoo

Test Point:
A statement may lower any number of escalated classes. A full-table UPDATE (lock_escalation 60) on a table of 20 range
partitions escalates p1 to p19, and every one of them is lowered at statement end: another transaction inserts into
p0, p16, p17 and p19 without waiting, before the first transaction commits.

NUM_CLIENTS = 2
C1: SET SYSTEM PARAMETERS 'lock_escalation=60';
C1: UPDATE t27238_pt SET v = v + 1;
C2: INSERT INTO t27238_pt VALUES (2, 5);
C2: INSERT INTO t27238_pt VALUES (802, 5);
C2: INSERT INTO t27238_pt VALUES (852, 5);
C2: INSERT INTO t27238_pt VALUES (952, 5);
C2: COMMIT;
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
/* lock_escalation is a server parameter: a case that stopped before its clean up can leave another value */
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
C1: DROP TABLE IF EXISTS t27238_pt;
C1: CREATE TABLE t27238_pt (id INT PRIMARY KEY, v INT) PARTITION BY RANGE (id) ( PARTITION p0 VALUES LESS THAN (50), PARTITION p1 VALUES LESS THAN (100), PARTITION p2 VALUES LESS THAN (150), PARTITION p3 VALUES LESS THAN (200), PARTITION p4 VALUES LESS THAN (250), PARTITION p5 VALUES LESS THAN (300), PARTITION p6 VALUES LESS THAN (350), PARTITION p7 VALUES LESS THAN (400), PARTITION p8 VALUES LESS THAN (450), PARTITION p9 VALUES LESS THAN (500), PARTITION p10 VALUES LESS THAN (550), PARTITION p11 VALUES LESS THAN (600), PARTITION p12 VALUES LESS THAN (650), PARTITION p13 VALUES LESS THAN (700), PARTITION p14 VALUES LESS THAN (750), PARTITION p15 VALUES LESS THAN (800), PARTITION p16 VALUES LESS THAN (850), PARTITION p17 VALUES LESS THAN (900), PARTITION p18 VALUES LESS THAN (950), PARTITION p19 VALUES LESS THAN (1000));
C1: INSERT INTO t27238_pt SELECT ROWNUM * 2 - 1, 0 FROM db_class x, db_class y, db_class z LIMIT 499;
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: SET SYSTEM PARAMETERS 'lock_escalation=60';
MC: wait until C1 ready;
C1: UPDATE t27238_pt SET v = v + 1;
MC: wait until C1 ready;
C2: INSERT INTO t27238_pt VALUES (2, 5);
MC: wait until C2 ready;
C2: INSERT INTO t27238_pt VALUES (802, 5);
MC: wait until C2 ready;
C2: INSERT INTO t27238_pt VALUES (852, 5);
MC: wait until C2 ready;
C2: INSERT INTO t27238_pt VALUES (952, 5);
MC: wait until C2 ready;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;

/* expected end state */
/* expect 1 */
C2: SELECT v FROM t27238_pt WHERE id = 1;
MC: wait until C2 ready;
/* expect 5 */
C2: SELECT v FROM t27238_pt WHERE id = 852;
MC: wait until C2 ready;
/* expect 503 */
C2: SELECT COUNT(*) FROM t27238_pt;
MC: wait until C2 ready;
/* expect 519 */
C2: SELECT SUM(v) FROM t27238_pt;
MC: wait until C2 ready;

/* clean up */
C1: rollback work;
MC: wait until C1 ready;
C2: rollback work;
MC: wait until C2 ready;
C1: SET SYSTEM PARAMETERS 'lock_escalation=100000';
MC: wait until C1 ready;
C1: DROP TABLE t27238_pt;
C1: commit work;
MC: wait until C1 ready;

C1: quit;
C2: quit;
