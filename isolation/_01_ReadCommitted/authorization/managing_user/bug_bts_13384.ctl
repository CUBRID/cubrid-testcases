/*
Test Case: Changing Owner
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: create user aaa groups dba;
MC: wait until C1 ready;

C2: login as 'aaa';
MC: wait until C2 blocked;

C1: COMMIT;
MC: wait until C1 ready;

C2: login as 'aaa';
C2: select 1 from db_root;
MC: wait until C2 ready;


C1: quit;
C2: quit;

