/*
Test Case: alter synonym
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t2_1;
C1: DROP TABLE IF EXISTS t2_2;
C1: CREATE TABLE t2_1 (c1 varchar, c2 int);
C1: CREATE TABLE t2_2 (c1 varchar, c2 int);
C1: INSERT INTO t2_1 VALUES('t2_1', 1);
C1: INSERT INTO t2_2 VALUES('t2_2', 1);
C1: CREATE SYNONYM s2 FOR t2_1;
C1: commit;

/* test case */
C1: SELECT * FROM s2;
C2: SELECT * FROM s2;
C1: commit;
C2: commit;
C1: ALTER SYNONYM s2 FOR t2_2;
C1: SELECT * FROM s2;
MC: wait until C1 ready;
C2: SELECT * FROM s2;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;

C1: DROP SYNONYM IF EXISTS s2;
C1: DROP TABLE IF EXISTS t2_1;
C1: DROP TABLE IF EXISTS t2_2;
C1: commit;

C1: quit;
C2: quit;
