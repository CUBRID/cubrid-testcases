/*
Test Case: granting authorization
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

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: DROP TABLE IF EXISTS t2;
C1: CREATE USER company;
C1: CREATE USER engineering GROUPS company;
C1: CREATE USER jones GROUPS engineering; 
C1: CREATE USER brown;
C1: CREATE USER design MEMBERS brown;
C1: COMMIT;
MC: wait until C1 ready;

C1: CREATE TABLE t1 (id INT primary key);
C1: GRANT SELECT, UPDATE ON t1 TO company;
C1: GRANT SELECT, DELETE ON t1 TO design;
C1: GRANT SELECT, ALTER ON t1 TO brown;
C1: insert into t1 values (1),(2);
C1: COMMIT;
MC: wait until C1 ready;

C1: login as 'company';
C1: update t1 set id=10 where id=1;
C1: select * from t1 order by 1;
MC: wait until C1 ready;
C2: login as 'design';
C2: delete from t1 where id=2;
MC: wait until C2 ready;
C2: select * from t1 order by 1;
MC: wait until C2 ready;
C3: login as 'brown';
C3: ALTER table t1 ADD COLUMN name VARCHAR;
MC: wait until C3 blocked;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C3 ready;
C3: COMMIT;
MC: wait until C3 ready;
C2: select * from t1 order by 1;
C2: show COLUMNS in t1;
C2: COMMIT;
MC: wait until C2 ready;

C1: login as 'dba';
C1: DROP table t1;
C1: DROP USER jones;
C1: DROP USER brown;
C1: DROP USER design;
C1: DROP USER engineering;
C1: DROP USER company;
C1: COMMIT;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;

