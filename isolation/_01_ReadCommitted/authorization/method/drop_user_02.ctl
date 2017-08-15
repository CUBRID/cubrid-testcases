/*
Test Case: add_user
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 granting authorization, C2 verify authorization, 
C1 verify authorization, 
C1 commit, C2 commit, 
Metrics: data size = small, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will not be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 2
C1: granting authorization - verify authorization;  
C2: verify authorization;  
*/

MC: setup NUM_CLIENTS = 3;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: login as 'dba';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: CREATE USER company;
C1: CREATE USER design GROUPS dba;
C1: COMMIT;
MC: wait until C1 ready;

C1: login as 'company';
C1: CALL add_user ('jones', '') ON CLASS db_user;
C1: select name from db_user order by 1;
MC: wait until C1 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: login as 'design';
C2: CREATE USER jones;
C2: ALTER USER jones PASSWORD '123';
C2: select name from db_user order by 1;
MC: wait until C2 ready;
C3: CREATE USER brown;
MC: wait until C3 ready;
C2: COMMIT;
MC: wait until C3 ready;
C3: CALL drop_user ('jones') ON CLASS db_user;
C3: COMMIT;
MC: wait until C3 ready;
C2: CALL drop_user ('brown') ON CLASS db_user;
MC: wait until C2 ready;
C2: CALL login ('jones', '1234') ON CLASS db_user;
C2: COMMIT;
MC: wait until C2 ready;


C1: quit;
C2: quit;

C3: login as 'dba';
C3: DROP USER design;
C3: DROP USER company;
C3: COMMIT;
MC: wait until C3 ready;

C3: quit;

