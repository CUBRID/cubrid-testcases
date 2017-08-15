/*
Issue Case: CUBRIDSUS-16523
Priority: 1
Reference case:
Isolation Levels: Read Committed
Author: Ray

Test Plan: 
Test if the transaction can not see another transaction's update on db_user

Test Scenario:
C1 create user, C2 create user
C1 commit, C2 commit

Test Point:
1) C2 shouldn't needs to be blocked wait for C1 (locking)
2) C2 could see the C1 changes on db_user after C1 committed
*/

MC: setup NUM_CLIENTS = 2;

/* test point 1: repeatable read */
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
MC: wait until C1 ready;
MC: wait until C2 ready;

/* test case */
C1: login as 'dba';
C2: login as 'dba';
C1: CREATE USER user01;
MC: wait until C1 ready;
C2: CREATE USER user02;
C2: select name from db_user where name like '%USER%' order by 1;
/* expect: C2 doesn't need to wait for C1, USER02 is retrieved */
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select name from db_user where name like '%USER%' order by 1;
/* expect: USER01,USER02 is retrieved */
MC: wait until C2 ready;
C2: commit;

C1: login as 'dba';
C2: login as 'dba';
C1: DROP USER user01;
MC: wait until C1 ready;
C2: select name from db_user where name like '%USER%' order by 1;
/* expect: USER01,USER02 are retrieved */
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select name from db_user where name like '%USER%' order by 1;
/* expect: USER02 is retrieved */
MC: wait until C2 ready;
C2: commit;

C1: quit;
C2: quit;