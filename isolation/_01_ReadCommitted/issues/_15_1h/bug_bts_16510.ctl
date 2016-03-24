/*
Issue Case: CUBRIDSUS-16510
Priority: 1
Reference case:
Isolation Levels: Read Committed
Author: Ray

Test Plan: 
Test a locking issue when transactions create a user concurrently

Test Scenario:
C1 create user, C2 create user
C1 commit, C2 commit

Test Point:
1) C2 need to be blocked wait for C1 (locking)
2) C2 couldn't create a identical user since it has been created 
*/

MC: setup NUM_CLIENTS = 2;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;


/* test case1 */
C1: login as 'dba';
C2: login as 'dba';
C1: CREATE USER user01;
MC: wait until C1 ready;
C2: CREATE USER user01;
/* expect: C2 need to wait for C1 */
MC: wait until C2 blocked;
C1: commit;
/* expect: user01 is already existed and couldn't created by C2 */
MC: wait until C2 ready;
C2: select name from db_user where name like '%USER%';
MC: wait until C2 ready;
/* expect: USER01 is retrieved */
C2: commit;

C1: quit;
C2: quit;