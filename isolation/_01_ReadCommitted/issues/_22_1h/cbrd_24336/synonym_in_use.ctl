/*
Test Case: change synonyms in use
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout 5;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout 5;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP SYNONYM IF EXISTS s5_1;
C1: DROP SYNONYM IF EXISTS s5_2;
C1: DROP VIEW IF EXISTS v5_1;
C1: DROP TABLE IF EXISTS t5_1;
C1: DROP TABLE IF EXISTS t5_2;

C1: CREATE TABLE t5_1 (c1 varchar, c2 int);
C1: CREATE TABLE t5_2 (c1 varchar, c2 int);
C1: CREATE SYNONYM s5_1 FOR t5_1;
C1: CREATE SYNONYM s5_2 FOR t5_2;
C1: INSERT INTO s5_1 VALUES ('s5_1', 1);
C1: INSERT INTO s5_2 VALUES ('s5_2', 1);
C1: CREATE VIEW v5_1 AS SELECT * FROM s5_1;
C1: commit;

/* test case */
C1: SELECT * FROM s5_1;
MC: wait until C1 ready;
C2: CREATE OR REPLACE SYNONYM s5_1 FOR s5_2;
MC: wait until C2 blocked;
C2: ALTER SYNONYM s5_1 FOR s5_2;
MC: wait until C2 blocked;
C2: DROP SYNONYM s5_1;
MC: wait until C2 blocked;
C2: DROP TABLE t5_1;
MC: wait until C2 blocked;
MC: wait until C2 ready;
C1: commit;

C1: INSERT INTO s5_1 VALUES ('s5_1',2);
C2: CREATE OR REPLACE SYNONYM s5_1 FOR s5_2;
MC: wait until C2 blocked;
C2: ALTER SYNONYM s5_1 FOR s5_2;
MC: wait until C2 blocked;
C2: DROP SYNONYM s5_1;
MC: wait until C2 blocked;
C2: DROP TABLE t5_1;
MC: wait until C2 blocked;
MC: wait until C2 ready;
C1: commit;

C1: SELECT * FROM v5_1;
MC: wait until C1 ready;
C2: CREATE OR REPLACE SYNONYM s5_1 FOR s5_2;
MC: wait until C2 blocked;
C2: ALTER SYNONYM s5_1 FOR s5_2;
MC: wait until C2 blocked;
C2: DROP SYNONYM s5_1;
MC: wait until C2 blocked;
C2: DROP TABLE t5_1;
MC: wait until C2 blocked;
MC: wait until C2 ready;
C1: commit;
C2: commit;

C1: DROP SYNONYM IF EXISTS s5_1;
C1: DROP SYNONYM IF EXISTS s5_2;
C1: DROP VIEW IF EXISTS v5_1;
C1: DROP TABLE IF EXISTS t5_1;
C1: DROP TABLE IF EXISTS t5_2;
C1: commit;

C1: quit;
C2: quit;
