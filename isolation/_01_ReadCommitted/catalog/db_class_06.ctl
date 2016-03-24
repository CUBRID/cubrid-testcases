/*
Test Case: update,insert,delete & select db_class
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_class (by drop table) 
- C2 update db_class
- C3 delete db_class
- C4 select db_class 
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level read committed;
C1: commit;
C2: commit;
C3: commit;
C4: commit;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: DROP TABLE IF EXISTS tb3;
C1: DROP TABLE IF EXISTS tb4;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: CREATE TABLE tb2( id INT, col VARCHAR(10));
C1: commit;
MC: wait until C1 ready;

/* test case */
C4: select * from db_class where class_name like 'tb%';
MC: wait until C4 ready;

C1: CREATE TABLE tb3( id INT primary key, col VARCHAR(10));
C1: CREATE TABLE tb4(id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
MC: wait until C1 ready;

C2: alter table tb1 ADD COLUMN phone VARCHAR(13) DEFAULT '000-0000-0000';
C2: rename table tb2 as tb2_rename; 
C2: alter table tb1 add constraint pk_tb1_id_phone primary key (id,phone);
MC: wait until C2 ready;

C3: CREATE TABLE tb5( id INT primary key, col VARCHAR(10));
C3: drop table tb5;
C3: drop table tb1; 
MC: wait until C3 blocked;

C4: select * from db_class where class_name like 'tb%';
MC: wait until C4 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: drop table tb2_rename;
C4: select * from db_class where class_name like 'tb%';
C4: commit;
MC: wait until C4 ready;

C1: quit;
C2: quit;
C3: quit;
C4: quit;
