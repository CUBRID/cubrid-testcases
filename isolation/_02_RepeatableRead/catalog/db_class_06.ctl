/*
Test Case: update,insert,delete & select db_class
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_class (by drop table) 
- C2 update db_class
- C3 select db_class 
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C1: commit;
C2: commit;
C3: commit;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: CREATE TABLE tb2( id INT, col VARCHAR(10));
C1: commit;
MC: wait until C1 ready;

C1: alter table tb1 ADD COLUMN phone VARCHAR(13) DEFAULT '000-0000-0000';
C1: rename table tb2 as tb2_rename; 
C1: alter table tb1 add constraint pk_tb1_id_phone primary key (id,phone);
MC: wait until C1 ready;

C2: drop table tb1; 
MC: wait until C2 blocked;

C3: select * from db_class where class_name like 'tb%';
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: select * from db_class where class_name like 'tb%';
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C3: drop table tb2_rename;
C3: select * from db_class where class_name like 'tb%';
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
