/*
Test Case: read & write db_index_key  
Priority: 1
Reference case:
Author: Lily

Test Point:
- C1 read db_index_key 
- C2 write db_index_key 
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
C1: commit;

/* test case */
C1: CREATE TABLE tb1(id INT primary key,col VARCHAR(10));
MC: wait until C1 ready;

C2: select * from db_index_key where class_name like 'tb%';
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: commit;
MC: wait until C2 ready;
MC: sleep 1;

C1: CREATE TABLE tb2(id INT primary key,col VARCHAR(10));
MC: wait until C1 ready;

C2: select * from db_index_key where class_name like 'tb%';
MC: wait until C2 ready;
C1: commit;
C2: commit;

C2: quit;
C1: quit;
