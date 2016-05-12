/*
Test Case: create table & delete,insert,select,update
Priority: 1
Reference case:
Author: Lily

Test Point:
system table -- db_class.
*/

MC: setup NUM_CLIENTS = 2;
C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level repeatable read;
C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;
C2: commit;
/* preparation */
C1: DROP TABLE IF EXISTS tb1;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: INSERT INTO tb1 VALUES(2,'abc',10);
C1: select * from db_class where owner_name='PUBLIC' order by 1;
MC: wait until C1 ready;
C2: select * from db_class where owner_name='PUBLIC' order by 1;
C2: DROP TABLE IF EXISTS tb2;
C2: CREATE TABLE tb2(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;
C2: select * from db_class where owner_name='PUBLIC' order by 1;
C2: commit;
MC: wait until C2 ready;
C1: select * from db_class where owner_name='PUBLIC' order by 1;
C1: RENAME TABLE tb1 AS t1;
MC: wait until C1 ready;
C2: select * from db_class where owner_name='PUBLIC' order by 1;
C2: commit;
C1: commit;
MC: wait until C2 ready;
MC: wait until C1 ready;

C1: DROP TABLE IF EXISTS tb1;
C1: DROP TABLE IF EXISTS tb2;
C1: CREATE TABLE tb1(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
C1: CREATE TABLE tb2(id INT PRIMARY KEY,col VARCHAR(10), grade INT);
MC: wait until C1 ready;
C2: INSERT INTO tb1 VALUES(102,'computer',100);
MC: wait until C2 blocked;
C1: rollback;
MC: wait until C2 ready;
C2: select * from db_class where owner_name='PUBLIC' order by 1;
C2: commit;
MC: wait until C2 ready;
C1: quit;
C2: quit;

