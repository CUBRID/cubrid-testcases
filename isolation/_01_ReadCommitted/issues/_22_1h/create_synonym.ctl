/*
Test Case: create or replace synonym
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1_1;
C1: DROP TABLE IF EXISTS t1_2;
C1: CREATE TABLE t1_1 (c1 varchar, c2 int);
C1: CREATE TABLE t1_2 (c1 varchar, c2 int);
C1: INSERT INTO t1_1 VALUES('t1_1', 1);
C1: INSERT INTO t1_2 VALUES('t1_2', 1);
C1: CREATE SYNONYM s1 FOR t1_1;
C1: commit;

/* test case */
C1: SELECT * FROM s1;
C2: SELECT * FROM s1;
C1: commit;
C2: commit;
C1: CREATE OR REPLACE SYNONYM s1 FOR t1_2;
C1: SELECT * FROM s1;
C2: SELECT * FROM s1;
MC: wait until C2 blocked;
C1: commit;
C2: commit;
C1: DROP SYNONYM IF EXISTS s1;
C1: DROP TABLE IF EXISTS t1_1;
C1: DROP TABLE IF EXISTS t1_2;
C1: commit;

C1: quit;
C2: quit;
