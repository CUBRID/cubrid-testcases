/*
Test Case: GROUPS/MEMBERS
Priority: 1
Reference case:
Author: Bobo

Test Plan: 
Test update locks (X_LOCK on instance) and SELECT not need locks, they are not blocked each other.

Test Scenario:
C1 CREATE, C2 CREATE, 
C1 create table, C2 select, 
C1 commit, C2 commit, 
Metrics: data size = small, where clause = simple (multiple columns)

Test Point:
1) C1 and C2 will not be waiting 
2) All the data affected from C1 and C2 should be deleted

NUM_CLIENTS = 2
C1: CREATE USER - chang user and create table - select;  
C2: CREATE USER - chang user - select;  
*/

MC: setup NUM_CLIENTS = 2;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP table IF EXISTS t1;
C1: DROP table IF EXISTS t2;
C1: DROP table IF EXISTS t3;
C1: CREATE USER company;
C1: CREATE USER engineering GROUPS company;
C1: CREATE USER jones GROUPS engineering; 
MC: wait until C1 ready;
C2: CREATE USER brown;
C2: CREATE USER design MEMBERS brown;
MC: wait until C2 ready;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;

C1: login as 'company';
C1: CREATE TABLE t1(id int primary key, name VARCHAR(10));
C1: select name from db_user order by 1;
C1: show tables;
MC: wait until C1 ready;
C2: login as 'engineering';
C2: CREATE TABLE t2(id int primary key, name VARCHAR(10));
C2: CREATE TABLE t3(id int primary key, name VARCHAR(10));
C2: insert into company.t1 values (1, 'aaa');
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C2 ready;
C2: show tables;
C2: select * from company.t1 order by 1;
MC: wait until C2 ready;
C1: insert into company.t1 values (2, 'aaa');
C1: select * from company.t1 order by 1;
C1: COMMIT;
MC: wait until C1 ready;
C2: show tables;
C2: COMMIT;
MC: wait until C2 ready;
C1: select * from company.t1 order by 1;
C1: show tables;
C1: COMMIT;
MC: wait until C1 ready;

C1: login as 'dba';
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C1: DROP table company.t1;
C1: DROP table engineering.t2;
C1: DROP table engineering.t3;
C1: DROP USER jones;
C1: DROP USER brown;
MC: wait until C1 ready;
C2: login as 'dba';
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: DROP USER brown;
MC: wait until C2 blocked;
C1: COMMIT;
MC: wait until C2 ready;
C1: DROP USER engineering;
C1: DROP USER design;
C1: DROP USER company;
C1: COMMIT;
MC: wait until C1 ready;
C2: COMMIT;
MC: wait until C2 ready;

C1: quit;
C2: quit;

