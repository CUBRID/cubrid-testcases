/*
Test Case: update & delete db_index_key  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 update db_index_key 
- C2 delete db_index_key 
- C3 select from db_index_key
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
C1: DROP TABLE IF EXISTS tb2;
C1: create table tb1 (id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
C1: create table tb2 (id INT ,col VARCHAR(10), grade INT,email VARCHAR(20));
C1: alter table tb1 add constraint pk_tb1_id_col primary key(id,col);
C1: insert into tb1 values(1,'abcdefg',100,'sda');
C1: create index i_tb2_id_col on tb2 (id,col);
C1: insert into tb2 values(1,'abcdefg',100,'sda');
C1: commit;
MC: wait until C1 ready;

/* test case */
C2: alter index i_tb2_id_col on tb2(id, col DESC) REBUILD;
MC: wait until C1 ready;
C3: alter table tb1 drop constraint pk_tb1_id_col;
MC: wait until C2 ready;

C1: select * from db_index_key where class_name like 'tb%';
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C1: select * from db_index_key where class_name like 'tb%';
C1: commit;
MC: wait until C1 ready;

C2: alter index i_tb2_id_col on tb2(id, email) REBUILD;
MC: wait until C2 ready;
C3: drop index i_tb2_id_col on tb2;
MC: wait until C3 blocked;

C1: select * from db_index_key where class_name like 'tb%';
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: commit;
MC: wait until C3 ready;
C1: select * from db_index_key where class_name like 'tb%';
C1: commit;
MC: wait until C1 ready;

C1: quit;
C2: quit;
C3: quit;
