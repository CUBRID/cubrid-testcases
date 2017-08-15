/*
Test Case: insert & insert
Priority: 1
Reference case:
Author: Lily

Test Point:
 - no row locks acquired if no unique indexes
insert will not block insert

NUM_CLIENTS = 2
C1: insert into t values(1);
C2: insert into t values(1); -- can not be blocked
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;

/* preparation */
C1: drop table if exists t;
C1: create table t(id int);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: insert into t values(1);
MC: wait until C1 ready;

C2: insert into t values(1);
MC: wait until C2 ready;

C1: commit;
MC: wait until C1 ready;

C2: select * from t order by 1;
C2: commit;          
MC: wait until C2 ready;

C2: quit;
C1: quit;
