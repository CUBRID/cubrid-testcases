/*
Test Case: read & write db_attribute
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 write db_attribute
- C2 read db_attribute
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C1: commit;
C2: commit;

/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;

/* test case */
C1: CREATE TABLE tb1(id INT , grade INT,email VARCHAR(20));
C1: INSERT INTO tb1 VALUES(1,10,'mike@nnn.com');
C1: INSERT INTO tb1 VALUES(2,20,'sofy@nnn.com');
MC: wait until C1 ready;

C2: select attr_name,class_name,def_order,data_type from db_attribute where class_name like 'tb%' order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select attr_name,class_name,def_order,data_type from db_attribute where class_name like 'tb%' order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: CREATE TABLE tb2(id INT , grade INT,email VARCHAR(20));
C1: INSERT INTO tb1 VALUES(1,10,'mike@nnn.com');
MC: wait until C1 ready;

C2: select attr_name,class_name,def_order,data_type from db_attribute where class_name like 'tb%' order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select attr_name,class_name,def_order,data_type from db_attribute where class_name like 'tb%' order by 1,2;
C2: commit;
MC: wait until C2 ready; 

C2: quit;
C1: quit;
