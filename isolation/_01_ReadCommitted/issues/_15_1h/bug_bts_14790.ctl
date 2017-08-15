/*
Issue Case: CUBRIDSUS-14790
Priority: 1
Reference case:
Isolation Read Committed
Author: Ray

Test Plan: 
Test the deadlock victim selection has been improved by "Prefer a transaction has written less log records."

Test Scenario:
C1 update, C2 insert/update, the affected rows are overlapped with each other
C1 commit, C2 commit
Metrics: schema = single table, index = no index, data size = small, where clause = simple

Test Point:
1) C2 needs to wait for C1, and C1 needs to wait for C2 (i.e. deadlock)
2) Transaction C1/C2 should detect the deadlock if it has written less logs (deadlock victim selection)
*/

MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* test case 1: C1 has written less logs so C1 should detect the deadlock */
/* preparation */
C1: drop if exists t1;
C1: drop if exists t2;
C1: create table t1(a int);
C1: create table t2(a int);
C1: insert into t1 values(0);
C1: insert into t2 values(1);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set a=1;
MC: wait until C1 ready;

/* C2 transaction is younger than C1, but C2 will do more job and generate more logs than C1 */
C2: insert into t2 values(2);
C2: insert into t2 values(2);
C2: update t2 set a=2;
C2: update t1 set a=2;
/* expect: C2 does need to wait for C1 */
C1: update t2 set a=1;
/* expect: C1 is aborted and killed by system deadlock victim selection (since C1 has written less logs) */
MC: pause for deadlock resolution;

C1: select * from t2;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
 
C2: select * from t1;
MC: wait until C2 ready;
C2: select * from t2;
MC: wait until C2 ready;
C2: commit;

/* test case 2: C2 has written less logs so C2 should detect the deadlock */
/* preparation */
C1: drop if exists t1;
C1: drop if exists t2;
C1: create table t1(a int);
C1: create table t2(a int);
C1: insert into t1 values(0);
C1: insert into t2 values(1);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: insert into t2 values(2);
C1: insert into t2 values(2);
C1: update t1 set a=1;
MC: wait until C1 ready;

/* C2 transaction is younger than C1, and C1 will do more job and generate more logs than C2 */
C2: update t2 set a=2;
C2: update t1 set a=2;
/* expect: C2 does need to wait for C1 */
MC: wait until C2 blocked;
C1: update t2 set a=1;
/* expect: C2 is aborted and killed by system deadlock victim selection (since C2 has written less logs) */
MC: pause for deadlock resolution;

C1: select * from t2;
C1: commit;
MC: wait until C1 ready;
C2: select * from t1;
MC: wait until C2 ready;
C2: commit;
MC: wait until C2 ready;
 
C2: select * from t1;
MC: wait until C2 ready;
C2: select * from t2;
MC: wait until C2 ready;
C2: commit;

C1: quit;
C2: quit;