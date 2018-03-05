MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout 5;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS xoo;
C1: create table xoo (a int primary key);
C1: insert into xoo values(5);
C1: commit;

C1: update xoo set a=a where a=5;
MC: wait until C1 ready;

C2: select * from xoo where a=5;
MC: wait until C2 ready;

C2: update xoo set a=a where a=5;
MC: wait until C2 blocked;

/*
 * C1 does not commit. C2 will be timedout.
C1: commit;
MC: wait until C1 ready;
 */

C2: select * from xoo where a=5;
C2: COMMIT;
MC: wait until C2 ready;

C1: quit;
C2: quit;
