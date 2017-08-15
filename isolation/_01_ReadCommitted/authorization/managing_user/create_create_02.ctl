/*
Test Case: CREATE USER
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 ALTER, C2 ALTER, C3 select
C1 commit, C2 commit, C3 commit
Metrics: data size = small, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will not be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 3
C1: CREATE USER - select;  
C2: CREATE USER - select;  
C2: select - select;  
*/

MC: setup NUM_CLIENTS = 3;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: login as 'public';
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C3: select name from db_user order by 1;
MC: wait until C3 ready;
C1: CREATE USER Fred;
MC: wait until C1 ready;
C2: CREATE USER Fred1;
MC: wait until C2 ready;
C1: select name from db_user order by 1;
MC: wait until C1 ready;
C2: select name from db_user order by 1;
MC: wait until C2 ready;
C2: select name from db_user order by 1;
C2: COMMIT;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;
C3: COMMIT;
C3: select name from db_user order by 1;
C3: COMMIT;
MC: wait until C3 ready;
C1: login as 'dba';
C1: DROP USER Fred;
C1: DROP USER Fred1;
C1: COMMIT;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;

