/*
Test case is from http://jira.cubrid.org/browse/CBRD-20469.
Select result incorrect on overflow record having size greater than 2 pages
*/

/* preparation */
MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C1: drop table if exists t1;
C1: create table t1 (id1 char (50000));
C1: insert into t1 values (1);
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: update t1 set id1 = 2 where id1 = 1;
MC: wait until C1 ready;

/* expact C2 return 1 row, value is 1. */
C2: select length(id1), substring(id1, 0, 10) from t1;
MC: wait until C2 ready; 

C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
