/*
Test Case: insert,update,delete & select db_attribute  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert db_attribute 
- C2 update db_attribute 
- C3 delete db_attribute
- C4 select from db_attribute
*/

MC: setup NUM_CLIENTS = 4;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C4: set transaction lock timeout INFINITE;
C4: set transaction isolation level repeatable read;
C2: commit;
C3: commit;
C4: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: DROP TABLE IF EXISTS tb_with_alotof_columns_with_diff_type;
C1: CREATE TABLE tb1( id INT primary key, col VARCHAR(10));
C1: CREATE TABLE tb2( id INT, col VARCHAR(10));
C1: create table tb_with_alotof_columns_with_diff_type(id int, name varchar(20), hire_date datetime, salary float,departno smallint,total bigint);
C1: create unique index tb_id_hire_date on tb_with_alotof_columns_with_diff_type(id,hire_date);
C1: commit;
MC: wait until C1 ready;

/* test case */
C2: alter table tb2 ADD COLUMN phone VARCHAR(13) DEFAULT '000-0000-0000' AFTER col;
C2: alter table tb_with_alotof_columns_with_diff_type ADD COLUMN phone VARCHAR(13) DEFAULT '000-0000-0000' AFTER name;
C2: alter table tb_with_alotof_columns_with_diff_type ADD COLUMN addr varchar(20) not null;
MC: wait until C2 ready;
C3: rename table tb1 as tb1_rename;
MC: wait until C3 blocked;
C2: commit;
MC: wait until C3 ready;
C4: alter table tb_with_alotof_columns_with_diff_type drop column salary,hire_date; 
MC: wait until C4 ready;

C1: select attr_name,class_name,data_type,default_value,is_nullable from db_attribute where class_name like 'tb%' order by 1,2,3,4,5;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C4: commit;
MC: wait until C4 ready;

C1: select attr_name,class_name,data_type,default_value,is_nullable from db_attribute where class_name like 'tb%' order by 1,2,3,4,5;
C1: commit;
C1: select attr_name,class_name,data_type,default_value,is_nullable from db_attribute where class_name like 'tb%' order by 1,2,3,4,5;
C1: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
