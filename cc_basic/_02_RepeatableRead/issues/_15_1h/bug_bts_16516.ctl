/*
Issue Case: CUBRIDSUS-16516
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Ray

Test Plan: 
Test a visibility problem of db_user when execute 'drop user' concurrently

Test Scenario:
C1 drop user, C2 drop user
C1 commit, C2 commit

Test Point:
1) C2 need to be blocked wait for C1 (locking)
2) C2 couldn't see the C1 changes on db_user after C1 committed since repeatable read
*/

MC: setup NUM_CLIENTS = 2;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: login as 'dba';
C1: CREATE USER user01;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case1 */
C1: login as 'dba';
C2: login as 'dba';
C1: DROP USER user01;
MC: wait until C1 ready;
C2: DROP USER user01;
/* expect: C2 need to wait for C1 */
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: select name from db_user where name like '%USER%' order by 1;
MC: wait until C2 ready;
/* expect: USER01 is retrieved */
C2: commit;

/* preparation */
C1: login as 'dba';
C1: CREATE USER user01;
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case2 */
C1: login as 'dba';
C2: login as 'dba';
C1: DROP USER user01;
MC: wait until C1 ready;
C2: select name from db_user where name like '%USER%' order by 1;
/* expect: C2 doesn't need to wait for C1 */
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select name from db_user where name like '%USER%' order by 1;
MC: wait until C2 ready;
/* expect: USER01 is retrieved */
C2: commit;

C1: quit;
C2: quit;