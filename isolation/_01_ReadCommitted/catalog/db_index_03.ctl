/*
Test Case: update & update db_index  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 update db_index 
- C2 update db_index 
- C3 select from db_index
*/

MC: setup NUM_CLIENTS = 3;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;
C2: commit;
C3: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: create table tb1 (id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
C1: create table tb2 (id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
C1: alter table tb1 add constraint pk_tb1_id_col primary key(id,col);
C1: create index i_tb2_id_col on tb2 (id,col);
C1: insert into tb2 values(1,'abcdefg',100,'sda');
C1: insert into tb2 values(1,'abcdeag',100,'sda');
C1: commit;

/* test case */
C1: rename table tb1 as tb1_rename;
MC: wait until C1 ready;
C2: alter index i_tb2_id_col on tb2 REBUILD;
MC: wait until C2 ready;

C3: select * from db_index where class_name like 'tb%';
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_index where class_name like 'tb%';
C3: commit;
MC: wait until C3 ready;

C1: alter table tb2 add constraint fk_id_col foreign key (id,col) references t1 (id,col);
MC: wait until C1 ready;
C2: alter index i_tb2_id_col on tb2 REBUILD;
MC: wait until C2 blocked;

C3: select * from db_index where class_name like 'tb%';
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_index where class_name like 'tb%';
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
