/*
Test Case: update & update db_class
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 update db_class (by rename or alter table) 
- C2 update db_class 
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
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: CREATE TABLE tb2( id INT, col VARCHAR(10));
C1: CREATE TABLE tb3( id INT, col VARCHAR(10));
C1: commit;
MC: wait until C1 ready;

/* test case */
/* update different table */
C1: alter tb1 ADD COLUMN age INT DEFAULT 0 NOT NULL; 
MC: wait until C1 ready;
C2: rename tb2 as tb2_rename;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%' order by 1,2;
MC: wait until C2 ready;
C1: drop table tb2_rename;
MC: wait until C1 blocked;
C2: commit;
MC: wait until C2 ready;
C1: commit;
C1: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%' order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* update same table */
C1: alter tb3 ADD COLUMN age INT DEFAULT 0 NOT NULL; 
MC: wait until C1 ready;
C2: rename tb3 as tb3_rename;
MC: wait until C2 blocked;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C1: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%' order by 1,2;
C1: commit;
C1: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%' order by 1,2;
C1: drop table tb3_rename;
C1: commit;
MC: wait until C2 ready;

C2: quit;
C1: quit;
