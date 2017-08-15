/*
Test Case: delete & delete db_attribute
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 delete db_attribute  
- C2 delete db_attribute 
- C3 select from db_attribute; 
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level repeatable read;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level repeatable read;
C2: commit;
C3: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT , grade INT,email VARCHAR(20), addr varchar(50));
C1: INSERT INTO tb1 VALUES(1,10,'mike@nnn.com','abc');
C1: CREATE TABLE tb2(id INT primary key, name varchar(20), grade INT,email VARCHAR(20), addr varchar(50));
C1: INSERT INTO tb2 VALUES(1,'tom',10,'mike@nnn.com','efg');
C1: create unique index idx on tb2(id,name);
C1: commit;
MC: wait until C1 ready;

/* test case */
/* different table */
C1: alter table tb1 drop column grade,email;
MC: wait until C1 ready;
C2: alter table tb2 drop column grade;
MC: wait until C2 ready;
C3: select * from db_attribute where class_name like 'tb%' order by 1,2;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_attribute where class_name like 'tb%' order by 1,2;
C3: commit;
C3: select * from db_attribute where class_name like 'tb%' order by 1,2;
C3: commit;
MC: wait until C3 ready;

/* same table different column */
C2: ALTER TABLE tb2 drop column email;
MC: wait until C2 ready;
C3: ALTER TABLE tb2 drop column name;
MC: wait until C3 blocked;
C1: select * from db_attribute where class_name like 'tb%' order by 1,2;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C1: commit;
C1: select * from db_attribute where class_name like 'tb%' order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* same table same column */
C2: ALTER TABLE tb2 drop column addr;
MC: wait until C2 ready;
C3: rename tb2 as tb2_rename;
MC: wait until C3 blocked;
C1: select * from db_attribute where class_name like 'tb%' order by 1,2;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C1: commit;
C1: select * from db_attribute where class_name like 'tb%' order by 1,2;
C1: drop table tb2_rename;
C1: commit;
MC: wait until C1 ready;

C3: quit;
C2: quit;
C1: quit;
