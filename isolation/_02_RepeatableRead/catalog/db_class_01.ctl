/*
Test Case: read & write db_class
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 write db_class (create and drop table) 
- C2 read db_class
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
C1: INSERT INTO tb1 VALUES(1,'abc',10,'mike@nnn.com');
C1: INSERT INTO tb1 VALUES(2,'edf',20,'sofy@nnn.com');
C1: commit;

/* test case */
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb2(id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
MC: wait until C1 ready;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: show tables;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: show tables;
C2: drop table tb2;
MC: wait until C2 ready;
C1: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C1: show tables;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: CREATE TABLE tb2(id INT , name VARCHAR(10), email VARCHAR(20));
C1: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C1: show tables;
C1: commit;


C2: quit;
C1: quit;
