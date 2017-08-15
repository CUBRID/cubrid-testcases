/*
Test Case: insert & insert db_index  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 insert into db_index 
- C2 insert into db_index 
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
C1: DROP TABLE IF EXISTS tb2;
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT primary key,col VARCHAR(10));
C1: commit;
MC: wait until C1 ready;

/* test case */
C1: create unique index idx on tb1(col);
MC: wait until C1 ready;
C2: create table tb2 (t1_id int not null,col varchar(10));
C2: alter table tb2 add constraint tb1_id foreign key (t1_id) references tb1 (id);
MC: wait until C2 blocked;

C3: select * from db_index where class_name like 'tb%' order by 1,2,3,4;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_index where class_name like 'tb%' order by 1,2,3,4;
C3: commit;
MC: wait until C3 ready;
MC: sleep 1;

/* add same index on same table */
C1: create unique index idx on tb2(col);
MC: wait until C1 ready;
C2: alter table tb2 add constraint pk_tb2_id_col primary key (t1_id,col);
MC: wait until C2 blocked;

C3: select * from db_index where class_name like 'tb%' order by 1,2,3,4;
MC: wait until C3 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
C3: select * from db_index where class_name like 'tb%' order by 1,2,3,4;
C3: commit;
MC: wait until C3 ready;

C1: quit;
C2: quit;
C3: quit;
