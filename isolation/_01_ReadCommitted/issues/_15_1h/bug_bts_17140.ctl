/*
Issue Case: CUBRIDSUS-17140
Priority: 1
Reference case:
Isolation Levels: Read Committed
Author: Ray

Test Plan: 
Test if The cardinality was not updated automatically if access user is not dba

*/

MC: setup NUM_CLIENTS = 2;

/* Test1 : test the scenario with public dba */
C1: login as 'dba';
C2: login as 'dba';

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id int primary key,col varchar(10), grade int);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit work;

/* test case */
C1: DELETE FROM tb1 where id > 2;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD INDEX inx_1(grade DESC);
MC: wait until C2 blocked;
C1: commit work;
MC: wait until C1 ready;

MC: wait until C2 ready;
C2: SELECT * FROM tb1 order by 1,2; 
C2: show index from tb1;
C2: commit work;
MC: wait until C2 ready;

C1: DROP TABLE IF EXISTS tb1;
MC: wait until C1 ready;

/* Test2 : test the scenario with public user */
C1: login as 'public';
C2: login as 'public';

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id int primary key,col varchar(10), grade int);
C1: INSERT INTO tb1 VALUES(1,'abc',10);
C1: INSERT INTO tb1 VALUES(2,'efg',11);
C1: INSERT INTO tb1 VALUES(3,'hijk',12);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM tb1 where id > 2;
MC: wait until C1 ready;
C2: ALTER TABLE tb1 ADD INDEX inx_1(grade DESC);
MC: wait until C2 blocked;
C1: commit work;

MC: wait until C2 ready;
C2: SELECT * FROM tb1 order by 1,2; 
C2: show index from tb1;
C2: commit work;
MC: wait until C2 ready;

C2: quit;
C1: quit;