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
C1: create user aa; 
C1: drop table if exists t1;
C1: drop view if exists v1;
C1: create table t1 (b varchar(50));
C1: create view v1 as select b from t1;
C1: GRANT SELECT ON t1, v1 TO aa; 
C1: COMMIT;
MC: wait until C1 ready;

C2: login as 'aa';
MC: wait until C2 ready;

C1: REVOKE SELECT ON t1, v1 FROM aa; 
C1: COMMIT;
MC: wait until C1 ready;

C2: select * from (select 'OK' from v1 where b is NULL);
C2: select * from (select 'OK' from v1 where b is NULL);
MC: wait until C2 ready;

C1: quit;
C2: quit;

