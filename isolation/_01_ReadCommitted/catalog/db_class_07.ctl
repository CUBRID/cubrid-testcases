/*
Test Case: rollback db_class
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 make a lot of operation to table e.g create,rename, drop 
- C2 select from db_class
- C1 rollback;
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: DROP TABLE IF EXISTS tb3;
C1: DROP TABLE IF EXISTS tb_with_alotof_columns_with_diff_type;
C1: commit;

/* test case */
C1: CREATE TABLE tb1( id INT, col VARCHAR(10));
C1: CREATE TABLE tb2( id INT, col VARCHAR(10));
C1: CREATE TABLE tb3( id INT primary key, col VARCHAR(10));
C1: create table tb_with_alotof_columns_with_diff_type(id int, name varchar(20), hire_date datetime, salary float,departno smallint,total bigint);
C1: insert into tb3 values(1,'abc'),(2,'efg'),(3,'tee');
C1: rename tb3 as tb3_rename;
C1: alter table tb2 add constraint pk_tb2_id_col primary key (id,col);
MC: wait until C1 ready;

C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
MC: wait until C2 ready;
C1: commit;
C1: CREATE TABLE tb1_rollback( id INT, col VARCHAR(10), name varchar(30));
C1: CREATE TABLE tb2_rollback( id INT, col VARCHAR(10), grade int);
C1: CREATE TABLE tb3_rollback( id INT primary key, col VARCHAR(10), email varchar(50));
C1: alter table tb1 ADD COLUMN name VARCHAR FIRST;
C1: alter table tb2_rollback add constraint pk_tb2_rollback_id_col primary key (id,col);
C1: drop table tb3_rollback;
C1: alter table tb_with_alotof_columns_with_diff_type ADD COLUMN comment VARCHAR(1000) FIRST;
C1: insert into tb_with_alotof_columns_with_diff_type(id,name,salary,departno) values(100,'tomson',300.65,90);
MC: wait until C1 ready;
MC: sleep 1;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
MC: wait until C2 ready;
C1: rollback;
MC: wait until C1 ready;
C2: select class_name,owner_name,is_system_class from db_class where class_name like 'tb%';
C2: drop table tb3_rename;
C2: commit;

C2: quit;
C1: quit;
