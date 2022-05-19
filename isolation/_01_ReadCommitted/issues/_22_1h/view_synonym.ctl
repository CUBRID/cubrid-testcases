/*
Test Case: rename synonym with view
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t4_1;
C1: DROP TABLE IF EXISTS t4_2;
C1: CREATE TABLE t4_1 (c1 varchar, c2 int);
C1: CREATE TABLE t4_2 (c1 varchar, c2 int);
C1: CREATE VIEW v4_1 AS SELECT * FROM t4_1;
C1: CREATE SYNONYM s4_1 FOR v4_1;
C1: CREATE SYNONYM s4_2 FOR t4_2;
C1: commit;

/* test case */
C1: INSERT INTO s4_1 VALUES('t4_1', 1);
C1: INSERT INTO t4_1 VALUES('t4_1', 1);
C1: SELECT * FROM s4_1;
MC: wait until C1 ready;
C2: SELECT * FROM s4_1;
MC: wait until C2 ready;
C1: commit;
C2: SELECT * FROM s4_1;
C2: commit;
MC: wait until C2 ready;

C1: DROP TABLE t4_1;
C1: SELECT * FROM v4_1;
C1: SELECT * FROM s4_1;
MC: wait until C1 ready;
C2: SELECT * FROM s4_1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;

C1: DROP SYNONYM s4_1;
C1: RENAME SYNONYM s4_2 to s4_1;
C1: SELECT * FROM s4_1;
MC: wait until C1 ready;
C2: SELECT * FROM s4_1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;

C1: DROP SYNONYM IF EXISTS s4_1;
C1: DROP SYNONYM IF EXISTS s4_2;
C1: DROP VIEW IF EXISTS v4_1;
C1: DROP TABLE IF EXISTS t4_1;
C1: DROP TABLE IF EXISTS t4_2;
C1: commit;

C1: quit;
C2: quit;
