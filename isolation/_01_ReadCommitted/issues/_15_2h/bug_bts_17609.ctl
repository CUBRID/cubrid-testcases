/*
Issue Case: CUBRIDSUS-17609
Priority: 1
Reference case:
Isolation Levels: Read Committed/Repeatable Read
Author: Ray

Test Plan: 
Test if there is a lost update on an updatable view

Test Scenario:
C1 update view, C2 update view
C1 commit, C2 commit

Test Point:
1) C2 should be blocked for C1 (locking)
2) C1 could see the C2 changes 
*/

MC: setup NUM_CLIENTS = 2;

/* test point1: test with read committed */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP VIEW IF EXISTS v1;
C1: DROP VIEW IF EXISTS v2;
C1: CREATE TABLE t1(a int);
C1: INSERT INTO t1 VALUES (1);
C1: CREATE VIEW v1 AS SELECT * from t1;
C1: CREATE VIEW v2 AS SELECT * from t1;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: update v1 set a=7 where a=1;
MC: wait until C1 ready;
/* expect: C2 need to wait for C1 */
C2: update v2 set a=6 where a=1;
MC: wait until C2 blocked;
C1: SELECT * FROM t1 order by 1;
C1: COMMIT;
MC: wait until C2 ready;
/* expect C2 could see C1 changes since read committed */
C2: SELECT * FROM t1 order by 1;
C2: COMMIT;
MC: wait until C2 ready;

/* test point2: test with repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP VIEW IF EXISTS v1;
C1: DROP VIEW IF EXISTS v2;
C1: CREATE TABLE t1(a int);
C1: INSERT INTO t1 VALUES (1);
C1: CREATE VIEW v1 AS SELECT * from t1;
C1: CREATE VIEW v2 AS SELECT * from t1;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: update v1 set a=7 where a=1;
MC: wait until C1 ready;
/* expect: C2 need to wait for C1 */
C2: update v2 set a=6 where a=1;
MC: wait until C2 blocked;
C1: SELECT * FROM t1 order by 1;
C1: COMMIT;
MC: wait until C2 ready;
/* expect C2 couldn't see C1 changes since repeatable read */
C2: SELECT * FROM t1 order by 1;
C2: COMMIT;
MC: wait until C2 ready;

C1: quit;
C2: quit;
