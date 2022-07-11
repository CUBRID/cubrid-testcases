/*
Test Case: rename synonym, drop synonym
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t3_1;
C1: DROP TABLE IF EXISTS t3_2;
C1: CREATE TABLE t3_1 (c1 varchar, c2 int);
C1: CREATE TABLE t3_2 (c1 varchar, c2 int);
C1: CREATE SYNONYM s3_1 FOR t3_1;
C1: CREATE SYNONYM s3_2 FOR t3_2;
C1: INSERT INTO s3_1 VALUES('t3_1', 1);
C1: INSERT INTO s3_2 VALUES('t3_2', 1);
C1: commit;

/* test case */
C1: SELECT * FROM s3_1;
C2: SELECT * FROM s3_1;
C1: commit;
C2: commit;
C1: DROP SYNONYM s3_1;
C1: SELECT * FROM s3_1;
MC: wait until C1 ready;
C2: SELECT * FROM s3_1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;

C1: RENAME SYNONYM s3_2 to s3_1;
C1: SELECT * FROM s3_1;
MC: wait until C1 ready;
C2: SELECT * FROM s3_1;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;

C1: DROP SYNONYM IF EXISTS s3_1;
C1: DROP SYNONYM IF EXISTS s3_2;
C1: DROP TABLE IF EXISTS t3_1;
C1: DROP TABLE IF EXISTS t3_2;
C1: commit;

C1: quit;
C2: quit;
