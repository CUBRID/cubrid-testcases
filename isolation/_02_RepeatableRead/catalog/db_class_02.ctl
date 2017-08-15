/*
Test Case: insert & insert db_class
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert into db_class (by create table) 
- C2 insert into db_class 
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: DROP TABLE IF EXISTS tb3;
C1: commit;

/* test case */
/* create different table */
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
MC: wait until C1 ready;
C2: CREATE TABLE tb2( id INT, col VARCHAR(10));
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: show tables;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: show tables;
C2: commit;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: show tables;
C2: commit;
MC: wait until C2 ready;

/* create same table */
C1: CREATE TABLE tb3( id INT, col VARCHAR(10));
MC: wait until C1 ready;
C2: CREATE TABLE tb3( id INT, col VARCHAR(10), grade int);
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: commit;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
