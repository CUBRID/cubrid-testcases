/*
Issue Case: CUBRIDSUS-14852
Priority: 1
Reference case:
Isolation Levels: Read Committed 
Author: Ray

Test Plan: 
Test the scenario to check if there is a reevaluation problem when concurrent transactions operate ddl

Test Scenario:
C1 alter, C2 describe
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 should needs to be blocked wait for C1 (locking)
2) C2 could see the C1 changes since read committed
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* test point 1: alter&select */
/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1 (i int);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values(1);
C1: alter table t1 change column i j int;
MC: wait until C1 ready;
C2: select * from t1 order by 1; 
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: commit;

/* test point 2: alter:describe */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1 (i int);
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: insert into t1 values(1);
C1: alter table t1 change column i j int;
MC: wait until C1 ready;
C2: describe t1; 
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: commit;

C1: quit;
C2: quit;