/*
Issue Case: CUBRIDSUS-14804
Priority: 1
Reference case:
Isolation Levels: Repeatable Read
Author: Lily

Issue title: 
[MVCC][Repeatable read]The behavior is different when run 'alter table' twice.
*/
MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C1: drop table if exists t;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

/* preparation */
C1: CREATE TABLE t(id INT PRIMARY KEY,col VARCHAR(10));
C1: commit;
MC: wait until C1 ready;
/* test case */
C1: ALTER TABLE t ADD COLUMN email VARCHAR(20);
MC: wait until C1 ready;
C2: desc t;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C2 ready;
C2: ALTER TABLE t drop COLUMN email; 
C2: desc t;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
